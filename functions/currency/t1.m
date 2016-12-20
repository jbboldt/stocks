javaaddpath('jsoup-1.7.2')
url_string = 'http://finance.yahoo.com';
doc = org.jsoup.Jsoup.connect(url_string);
doc.get();
parser = org.jsoup.Jsoup.parse(char(doc.get()));
doc = parser.getElementsByTag('td');
text = {};
for i=1:doc.size
    text{i,1} =  char(doc.get(i-1).text());
end