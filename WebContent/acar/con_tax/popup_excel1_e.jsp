<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");

int total_su = 0;
long total_amt11 = 0;
long total_amt12 = 0;
long total_amt13 = 0;
long total_amt14 = 0;
long total_amt15 = 0;
long total_amt21 = 0;
long total_amt22 = 0;
long total_amt23 = 0;
long total_amt24 = 0;
long total_amt25 = 0;
long total_amt31 = 0;
long total_amt32 = 0;
long total_amt33 = 0;
long total_amt34 = 0;
long total_amt35 = 0;
long total_amt41 = 0;
long total_amt42 = 0;
long total_amt43 = 0;
long total_amt44 = 0;
long total_amt45 = 0;
String tax_rate1 = "";

Vector taxs1 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "3");
int tax_size1 = taxs1.size();
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
total_amt11   = total_amt11 + Long.parseLong(String.valueOf(tax1.get("CAR_FS_AMT")));
total_amt12   = total_amt12 + Long.parseLong(String.valueOf(tax1.get("과세표준")));
total_amt13   = total_amt13 + Long.parseLong(String.valueOf(tax1.get("산출개별소비세")));
total_amt14   = total_amt14 + Long.parseLong(String.valueOf(tax1.get("산출교육세")));
total_amt15   = total_amt15 + Long.parseLong(String.valueOf(tax1.get("AMT")));
tax_rate1 = (String)tax1.get("TAX_RATE");
}}
Vector taxs2 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "2");
int tax_size2 = taxs2.size();
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
total_amt21   = total_amt21 + Long.parseLong(String.valueOf(tax2.get("CAR_FS_AMT")));
total_amt22   = total_amt22 + Long.parseLong(String.valueOf(tax2.get("과세표준")));
total_amt23   = total_amt23 + Long.parseLong(String.valueOf(tax2.get("산출개별소비세")));
total_amt24   = total_amt24 + Long.parseLong(String.valueOf(tax2.get("산출교육세")));
total_amt25   = total_amt25 + Long.parseLong(String.valueOf(tax2.get("AMT")));
}}
Vector taxs3 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "1");
int tax_size3 = taxs3.size();
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
total_amt31   = total_amt31 + Long.parseLong(String.valueOf(tax3.get("CAR_FS_AMT")));
total_amt32   = total_amt32 + Long.parseLong(String.valueOf(tax3.get("과세표준")));
total_amt33   = total_amt33 + Long.parseLong(String.valueOf(tax3.get("산출개별소비세")));
total_amt34   = total_amt34 + Long.parseLong(String.valueOf(tax3.get("산출교육세")));
total_amt35   = total_amt35 + Long.parseLong(String.valueOf(tax3.get("AMT")));
}}
Vector taxs4 = t_db.getTaxExcelList1_1(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "4");
int tax_size4 = taxs4.size();
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
total_amt41   = total_amt41 + Long.parseLong(String.valueOf(tax4.get("CAR_FS_AMT")));
total_amt42   = total_amt42 + Long.parseLong(String.valueOf(tax4.get("과세표준")));
total_amt43   = total_amt43 + Long.parseLong(String.valueOf(tax4.get("산출개별소비세")));
total_amt44   = total_amt44 + Long.parseLong(String.valueOf(tax4.get("산출교육세")));
total_amt45   = total_amt45 + Long.parseLong(String.valueOf(tax4.get("AMT")));

}}
String gsgg_dt = ""; //과세기간년월 ex)201301
//분기별 과세기간 선택
if(nb_dt.equals("04")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("07")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}else if(nb_dt.equals("10")){
	gsgg_dt = (AddUtil.parseInt(AddUtil.getDate(1))-1)+nb_dt;
}else if(nb_dt.equals("01")){
	gsgg_dt = AddUtil.getDate(1)+nb_dt;
}
%>
<table border="1" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>반출구분</td>
		<td>반출구분명</td>
		<td>구분코드</td>
		<td>구분코드명</td>
		<td>반출연월일</td>
		<td>과세물품종류</td>
		<td>과세물품종류명</td>
		<td>과세물품명</td>
		<td>규격</td>
		<td>차대번호</td>
		<td>수량</td>
		<td>반출가격</td>
		<td>과세표준</td>
		<td>세율</td>
		<td>세액</td>
		<td>산출세액</td>
		<td>면세미납세액</td>
		<td>공제세액</td>
		<td>납부할세액</td>
		<td>교육세</td>
		<td>농어촌특별세</td>
		<td>반입처사업자등록번호</td>
		<td>반입처상호</td>
		<td>반출승인번호/반입증명번호</td>
		<td>반입연월일</td>
		<td>용도변경연월일</td>
		<td>차종별용도(영업용구분)</td>
		<td>잔존가치율</td>
	</tr>
<%
//과세물품총판매(반출)명세서 시작 -------------------------------------------------------------------------
if(tax_size1 > 0){
for(int i = 0 ; i < tax_size1 ; i++){
Hashtable tax1 = (Hashtable)taxs1.elementAt(i);
%>
	<tr>
		<td align="center"><%="'01"%></td>
		<td align="center"></td>
		<td align="center">200001</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax1.get("TAX_COME_DT")))%></td>
		<td align="center">51041</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.rpad((String)(tax1.get("CAR_NO")),29," ")%></td>
		<td align="center">대</td>
		<td align="center"><%=AddUtil.rpad((String)(tax1.get("CAR_NUM")),30," ")%></td>
		<td align="center">1</td>
		<td align="center"><%=AddUtil.lpad((String)tax1.get("CAR_FS_AMT"),13,"0")%></td>
		<td align="center"><!--과세표준--></td>
		<td align="center"><!--세율--></td>
		<td align="center"><!--세액--></td>
		<td align="center"><!--산출세액--></td>
		<td align="center"><!--면세미납세액--></td>
		<td align="center">0</td>
		<td align="center"><!--납부할세액--></td>
		<td align="center"><!--교육세--></td>
		<td align="center"><!--농어촌특별세--></td>
		<td align="center">128-81-47957</td>
		<td align="center">(주)아마존카</td>
		<td align="center"><!--반출승인번호--></td>
		<td align="center"><%=(String)(tax1.get("INIT_REG_DT"))%></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax1.get("RENT_START_DT")))%></td>
		<td align="center">Y</td>
		<td align="center"><!--잔존가치율--></td>
	</tr>
<%}}%>	

<%
if(tax_size2 > 0){
for(int i = 0 ; i < tax_size2 ; i++){
Hashtable tax2 = (Hashtable)taxs2.elementAt(i);
%>
	<tr>
		<td align="center"><%="'01"%></td>
		<td align="center"></td>
		<td align="center">200001</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax2.get("TAX_COME_DT")))%></td>
		<td align="center">51042</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.rpad((String)(tax2.get("CAR_NO")),29," ")%></td>
		<td align="center">대</td>
		<td align="center"><%=AddUtil.rpad((String)(tax2.get("CAR_NUM")),30," ")%></td>
		<td align="center">1</td>
		<td align="center"><%=AddUtil.lpad((String)tax2.get("CAR_FS_AMT"),13,"0")%></td>
		<td align="center"><!--과세표준--></td>
		<td align="center"><!--세율--></td>
		<td align="center"><!--세액--></td>
		<td align="center"><!--산출세액--></td>
		<td align="center"><!--면세미납세액--></td>
		<td align="center">0</td>
		<td align="center"><!--납부할세액--></td>
		<td align="center"><!--교육세--></td>
		<td align="center"><!--농어촌특별세--></td>
		<td align="center">128-81-47957</td>
		<td align="center">(주)아마존카</td>
		<td align="center"><!--반출승인번호--></td>
		<td align="center"><%=(String)(tax2.get("INIT_REG_DT"))%></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax2.get("RENT_START_DT")))%></td>
		<td align="center">Y</td>
		<td align="center"><!--잔존가치율--></td>
	</tr>
<%}}%>
<%
if(tax_size3 > 0){
for(int i = 0 ; i < tax_size3 ; i++){
Hashtable tax3 = (Hashtable)taxs3.elementAt(i);
%>
	<tr>
		<td align="center"><%="'01"%></td>
		<td align="center"></td>
		<td align="center">200001</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax3.get("TAX_COME_DT")))%></td>
		<td align="center">51042</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.rpad((String)(tax3.get("CAR_NO")),29," ")%></td>
		<td align="center">대</td>
		<td align="center"><%=AddUtil.rpad((String)(tax3.get("CAR_NUM")),30," ")%></td>
		<td align="center">1</td>
		<td align="center"><%=AddUtil.lpad((String)tax3.get("CAR_FS_AMT"),13,"0")%></td>
		<td align="center"><!--과세표준--></td>
		<td align="center"><!--세율--></td>
		<td align="center"><!--세액--></td>
		<td align="center"><!--산출세액--></td>
		<td align="center"><!--면세미납세액--></td>
		<td align="center">0</td>
		<td align="center"><!--납부할세액--></td>
		<td align="center"><!--교육세--></td>
		<td align="center"><!--농어촌특별세--></td>
		<td align="center">128-81-47957</td>
		<td align="center">(주)아마존카</td>
		<td align="center"><!--반출승인번호--></td>
		<td align="center"><%=(String)(tax3.get("INIT_REG_DT"))%></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax3.get("RENT_START_DT")))%></td>
		<td align="center">Y</td>
		<td align="center"><!--잔존가치율--></td>
	</tr>
<%}}%>
<%
if(tax_size4 > 0){
for(int i = 0 ; i < tax_size4 ; i++){
Hashtable tax4 = (Hashtable)taxs4.elementAt(i);
%>
	<tr>
		<td align="center"><%="'01"%></td>
		<td align="center"></td>
		<td align="center">200001</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax4.get("TAX_COME_DT")))%></td>
		<td align="center">51045</td>
		<td align="center"></td>
		<td align="center"><%=AddUtil.rpad((String)(tax4.get("CAR_NO")),29," ")%></td>
		<td align="center">대</td>
		<td align="center"><%=AddUtil.rpad((String)(tax4.get("CAR_NUM")),30," ")%></td>
		<td align="center">1</td>
		<td align="center"><%=AddUtil.lpad((String)tax4.get("CAR_FS_AMT"),13,"0")%></td>
		<td align="center"><!--과세표준--></td>
		<td align="center"><!--세율--></td>
		<td align="center"><!--세액--></td>
		<td align="center"><!--산출세액--></td>
		<td align="center"><!--면세미납세액--></td>
		<td align="center">0</td>
		<td align="center"><!--납부할세액--></td>
		<td align="center"><!--교육세--></td>
		<td align="center"><!--농어촌특별세--></td>
		<td align="center">128-81-47957</td>
		<td align="center">(주)아마존카</td>
		<td align="center"><!--반출승인번호--></td>
		<td align="center"><%=(String)(tax4.get("INIT_REG_DT"))%></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax4.get("RENT_START_DT")))%></td>
		<td align="center">Y</td>
		<td align="center"><!--잔존가치율--></td>
	</tr>
<%}}
//과세물품총판매(반출)명세서 끝 -------------------------------------------------------------------------
%>
</table>
</body>
</html>