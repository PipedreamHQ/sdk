#!/bin/bash
# absolutely beautiful script

js=dist/snippet.js
npx uglifyjs src/integrations/browser/snippet.js > $js
sed -i '' 's/})();$//' $js
echo -n $(cat $js) > $js
echo ';' >> $js
echo 'pdsdk.load();' >> $js
echo '})();' >> $js

html=dist/snippet.html
echo '<script type="text/javascript">' > $html
cat $js >> $html
echo '</script>' >> $html
