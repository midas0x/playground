// Adaption of github.com/prettier-solidity/prettier-plugin-solidity#configuration-file
module.exports = {
  overrides: [
    {
      files: "*.sol",
      options: {
        printWidth: 80,
        tabWidth: 4,
        useTabs: false,
        singleQuote: false,
        bracketSpacing: true,
        explicitTypes: "always",
      },
    },
  ],
};
