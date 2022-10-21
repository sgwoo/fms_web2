<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"13":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
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
	
	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>

<table border="1" cellspacing="0" cellpadding="0" width=1450>
  <tr> 
    <td colspan="17" align="center"><font face="돋움" size="5" ><b>장기대여시 12개월 도래 차량</b></font></td>
  </tr>
  <tr align="center"> 
    <td width='90' height="50">등록일자</td>
    <td width='90' height="50">출고일자</td>
    <td width='90' height="50">대여개시일</td>
    <td width='90' height="50">차량번호</td>
    <td width='150' height="50">차대번호</td>
    <td width="150" height="50">차량명</td>
    <td width='30' height="50">배기량</td>
    <td width='100' height="50">면세구입가<br>(반출가격)</td>
    <td width='60' height="50">친환경차<br>감면세액</td>
    <td width='60' height="50">신차<br>감면세액</td>
    <td width='60' height="50">잔가율</td>
    <td width='100' height="50">잔존가<br>(과세표준)</td>
    <td width='60' height="50">특소<br>세율</td>
    <td width='90' height="50">개별소비세</td>
    <td width='90' height="50">교육세</td>
    <td width="90" height="50">합계</td>
    <td width="50" height="50">수입차<br>과세<br>점검</td>
  </tr>
  <%	Vector taxs1 = t_db.getTaxExcelList1(br_id, gubun1, gubun2, gubun3, "1", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "3");
			int tax_size1 = taxs1.size();%>
  <%  if(tax_size1 > 0){
				for(int i = 0 ; i < tax_size1 ; i++){
					Hashtable tax1 = (Hashtable)taxs1.elementAt(i);%>
  <tr> 
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax1.get("INIT_REG_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax1.get("DLV_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax1.get("RENT_START_DT2")))%>&nbsp;</td>
    <td align='center' valign="middle"><%=tax1.get("CAR_NO")%></td>
    <td align='center' valign="middle"><%=tax1.get("CAR_NUM")%></td>
    <td align='center' valign="middle"><%=tax1.get("CAR_NM")%></td>
    <td align='center' valign="middle">3</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("CAR_FS_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("BK_122")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("CH_327")))%></td>
    <td align='right' valign="middle"><%=tax1.get("SUR_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("SUR_AMT")))%></td>
    <td align='right' valign="middle"><%=tax1.get("TAX_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("SPE_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("EDU_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax1.get("AMT")))%></td>
    <td align='center' valign="middle"><%=tax1.get("IMPORT_CHK")%></td>
  </tr>
  <%	
			total_amt11   = total_amt11 + Long.parseLong(String.valueOf(tax1.get("CAR_FS_AMT")));
			total_amt12   = total_amt12 + Long.parseLong(String.valueOf(tax1.get("SUR_AMT")));
			total_amt13   = total_amt13 + Long.parseLong(String.valueOf(tax1.get("SPE_TAX_AMT")));
			total_amt14   = total_amt14 + Long.parseLong(String.valueOf(tax1.get("EDU_TAX_AMT")));
			total_amt15   = total_amt15 + Long.parseLong(String.valueOf(tax1.get("AMT")));
  		}%>
  <tr> 
    <td align="center"><b>소계</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="center">&nbsp;</td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt11)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt12)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt13)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt14)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt15)%></b></td>
    <td align="center">&nbsp;</td>
  </tr>
  <%}%>
  <%Vector taxs2 = t_db.getTaxExcelList1(br_id, gubun1, gubun2, gubun3, "1", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "2");
	int tax_size2 = taxs2.size();%>
  <%  	if(tax_size2 > 0){
		for(int i = 0 ; i < tax_size2 ; i++){
			Hashtable tax2 = (Hashtable)taxs2.elementAt(i);%>
  <tr> 
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax2.get("INIT_REG_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax2.get("DLV_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax2.get("RENT_START_DT2")))%>&nbsp;</td>
    <td align='center' valign="middle"><%=tax2.get("CAR_NO")%></td>
    <td align='center' valign="middle"><%=tax2.get("CAR_NUM")%></td>
    <td align='center' valign="middle"><%=tax2.get("CAR_NM")%></td>
    <td align='center' valign="middle">2</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("CAR_FS_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("BK_122")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("CH_327")))%></td>
    <td align='right' valign="middle"><%=tax2.get("SUR_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("SUR_AMT")))%></td>
    <td align='right' valign="middle"><%=tax2.get("TAX_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("SPE_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("EDU_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax2.get("AMT")))%></td>
    <td align='center' valign="middle"><%=tax2.get("IMPORT_CHK")%></td>
  </tr>
  <%	
			total_amt21   = total_amt21 + Long.parseLong(String.valueOf(tax2.get("CAR_FS_AMT")));
			total_amt22   = total_amt22 + Long.parseLong(String.valueOf(tax2.get("SUR_AMT")));
			total_amt23   = total_amt23 + Long.parseLong(String.valueOf(tax2.get("SPE_TAX_AMT")));
			total_amt24   = total_amt24 + Long.parseLong(String.valueOf(tax2.get("EDU_TAX_AMT")));
			total_amt25   = total_amt25 + Long.parseLong(String.valueOf(tax2.get("AMT")));
  		}%>
  <tr> 
    <td align="center"><b>소계</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="center">&nbsp;</td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt21)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt22)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt23)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt24)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt25)%></b></td>
    <td align="center">&nbsp;</td>
  </tr>
  <%}%>
  <%Vector taxs3 = t_db.getTaxExcelList1(br_id, gubun1, gubun2, gubun3, "1", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, "1");
	int tax_size3 = taxs3.size();%>
  <%  	if(tax_size3 > 0){
		for(int i = 0 ; i < tax_size3 ; i++){
			Hashtable tax3 = (Hashtable)taxs3.elementAt(i);%>
  <tr> 
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax3.get("INIT_REG_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax3.get("DLV_DT")))%></td>
    <td align='center' valign="middle"><%=AddUtil.ChangeDate2(String.valueOf(tax3.get("RENT_START_DT2")))%>&nbsp;</td>
    <td align='center' valign="middle"><%=tax3.get("CAR_NO")%></td>
    <td align='center' valign="middle"><%=tax3.get("CAR_NUM")%></td>
    <td align='center' valign="middle"><%=tax3.get("CAR_NM")%></td>
    <td align='center' valign="middle">1</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("CAR_FS_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("BK_122")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("CH_327")))%></td>
    <td align='right' valign="middle"><%=tax3.get("SUR_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("SUR_AMT")))%></td>
    <td align='right' valign="middle"><%=tax3.get("TAX_RATE")%>%</td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("SPE_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("EDU_TAX_AMT")))%></td>
    <td align='right' valign="middle"><%=Util.parseDecimal(String.valueOf(tax3.get("AMT")))%></td>
    <td align='center' valign="middle"><%=tax3.get("IMPORT_CHK")%></td>
  </tr>
  <%	
			total_amt31   = total_amt31 + Long.parseLong(String.valueOf(tax3.get("CAR_FS_AMT")));
			total_amt32   = total_amt32 + Long.parseLong(String.valueOf(tax3.get("SUR_AMT")));
			total_amt33   = total_amt33 + Long.parseLong(String.valueOf(tax3.get("SPE_TAX_AMT")));
			total_amt34   = total_amt34 + Long.parseLong(String.valueOf(tax3.get("EDU_TAX_AMT")));
			total_amt35   = total_amt35 + Long.parseLong(String.valueOf(tax3.get("AMT")));
  		}%>
  <tr> 
    <td align="center"><b>소계</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="center">&nbsp;</td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt31)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt32)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt33)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt34)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt35)%></b></td>
    <td align="center">&nbsp;</td>
  </tr>
  <%}%>
  <tr> 
    <td align="center"><b>총합계</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt11+total_amt21+total_amt31)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt12+total_amt22+total_amt32)%></b></td>
    <td align="right"><b>&nbsp;</b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt13+total_amt23+total_amt33)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt14+total_amt24+total_amt34)%></b></td>
    <td align="right"><b><%=Util.parseDecimal(total_amt15+total_amt25+total_amt35)%></b></td>
    <td align="center">&nbsp;</td>
  </tr>
</table>
</body>
</html>
