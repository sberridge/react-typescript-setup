#!/bin/bash

mkdir src
mkdir build
touch build/index.html
echo "<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>React App</title>
</head>
<body>
    <div id=\"root\"></div>
    <script src=\"bundle.js\"></script>
</body>
</html>" >> build/index.html

touch src/index.tsx
echo "import React from \"react\";
import * as ReactDOMClient from \"react-dom/client\";

type AppProps = {
    title:string
}

const App = (props:AppProps) => {
    return (
        <div>
            <h1 className=\"title\">{props.title}</h1>
        </div>
    )
}

const rootEl = document.getElementById('root');

if(rootEl) {
    
    const root = ReactDOMClient.createRoot(rootEl);

    root.render(<App
        title=\"My App\"
    />);
}


export default App;" >> src/index.tsx

mkdir src/__tests__
touch src/__tests__/index.test.tsx

echo "import React from \"react\";
import {render} from '@testing-library/react';
import App from \"..\";


const createApp = (props:{title:string}) => {
    return <App
        title={props.title}
    ></App>
}

describe(\"Main App Test\",()=>{
    it(\"should render the app\",()=>{

        const comp = render(createApp({title: \"MyApp\"}));
        expect(comp.baseElement).toMatchSnapshot();
        expect(comp.queryByRole(\"heading\", {name: \"MyApp\"})).toBeTruthy();

    })
})" >> src/__tests__/index.test.tsx

npm init
npm install --save-dev webpack webpack-cli webpack-dev-server @babel/core @babel/runtime @babel/plugin-transform-runtime @babel/preset-env @babel/preset-react @babel/preset-typescript
npm install --save-dev @types/react @types/react-dom @types/webpack-dev-server @typescript-eslint/eslint-plugin @typescript-eslint/parser 
npm install --save-dev css-loader babel-loader style-loader ts-loader file-loader ts-node typescript sass sass-loader eslint eslint-plugin-react eslint-plugin-react-hooks html-webpack-plugin
npm install --save-dev jest babel-jest @types/jest jest-environment-jsdom @testing-library/react
npm install react react-dom

sed -i 's/\"test\": \"echo \\\"Error: no test specified\\\" && exit 1\"/\"test\": \"jest\",\n\t\"start\": \"webpack serve --open\",\n\t\"build\": \"webpack\"/' package.json

touch jest.config.ts
echo "import type {Config} from \"@jest/types\";

const config: Config.InitialOptions = {
    verbose: true,
    testEnvironment: \"jsdom\"
};

export default config;" >> jest.config.ts

touch tsconfig.json
echo "{
    \"compilerOptions\": {
        \"lib\": [\"dom\", \"dom.iterable\", \"esnext\"],
        \"allowJs\": true,
        \"allowSyntheticDefaultImports\": true,
        \"skipLibCheck\": true,
        \"esModuleInterop\": true,
        \"strict\": true,
        \"forceConsistentCasingInFileNames\": true,
        \"moduleResolution\": \"node\",
        \"resolveJsonModule\": true,
        \"isolatedModules\": true,
        \"noEmit\": true,
        \"jsx\": \"react-jsx\",
        \"types\": [\"jest\"]
    },
    \"include\": [\"src\"]
}" >> tsconfig.json


touch .eslintrc.json
echo "{
  \"parser\": \"@typescript-eslint/parser\",
  \"parserOptions\": {
    \"ecmaVersion\": 2018,
    \"sourceType\": \"module\"
  },
  \"plugins\": [
    \"@typescript-eslint\",
    \"react-hooks\"
  ],
  \"extends\": [
    \"plugin:react/recommended\",
    \"plugin:@typescript-eslint/recommended\"
  ],
  \"rules\": {
    \"react-hooks/rules-of-hooks\": \"error\",
    \"react-hooks/exhaustive-deps\": \"warn\",
    \"react/prop-types\": \"off\"
  },
  \"settings\": {
    \"react\": {
      \"pragma\": \"React\",
      \"version\": \"detect\"
    }
  }
}" >> .eslintrc.json


touch .babelrc
echo "{
    \"presets\": [
      \"@babel/preset-env\",
      \"@babel/preset-react\",
      \"@babel/preset-typescript\"
    ],
    \"plugins\": [
      [
        \"@babel/plugin-transform-runtime\",
        {
          \"regenerator\": true
        }
      ]
    ]
  }" >> .babelrc

touch webpack.config.ts
echo "import path from \"path\";
import * as webpack from \"webpack\";
import * as webpackDevServer from 'webpack-dev-server';

const config:webpack.Configuration = {
    entry: \"./src/index.tsx\",
    mode: \"development\",
    module: {
        rules: [
            {
                test: /\.(ts|js)x?$/,
                exclude: /node_modules/,
                use: {
                    loader: \"babel-loader\",
                    options: {
                        presets: [
                            \"@babel/preset-env\",
                            \"@babel/preset-react\",
                            \"@babel/preset-typescript\",
                        ]
                    }
                }
            },
            {
                test: /\.s[ac]ss$/i,
                use: [
                    'style-loader',
                    'css-loader',
                    'sass-loader'
                ]
            }
        ]
    },
    resolve: {
        extensions: [\".tsx\", \".ts\", \".js\"]
    },
    output: {
        path: path.resolve(__dirname, \"build\"),
        filename: \"bundle.js\"
    },
    devServer: {
        static: path.join(__dirname, \"build\"),
        compress: true,
        port: 4000
    },
};

export default config;" >> webpack.config.ts