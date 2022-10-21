<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String excel_s_dt = request.getParameter("excel_s_dt")==null?"":request.getParameter("excel_s_dt");
	String excel_e_dt = request.getParameter("excel_e_dt")==null?"":request.getParameter("excel_e_dt");
	
	Vector taxs = t_db.getTaxExcelList_e3(excel_s_dt, excel_e_dt);
	int tax_size = taxs.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("현재날짜 : "+ sdf.format(d));
		String filename = sdf.format(d)+"_개별소비세기간조회.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>반출구분</td>
		<td>구분코드</td>
		<td>반출연월일</td>
		<td>과세물품명</td>
		<td>규격</td>
		<td>차대번호</td>
		<td>수량</td>
		<td>반출가격</td>
		<td>친환경차감면세액</td>
		<td>신차감면세액</td>
		<td>과세표준</td>
		<td>세율</td>
		<td>산출세액</td>
		<td>교육세</td>
		<td>반입처사업자등록번호</td>
	</tr>
	<%
		//과세물품총판매(반출)명세서 시작 -------------------------------------------------------------------------
		if(tax_size > 0){
			for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
	%>
	<tr>
		<td align="center"><%=tax.get("ST1")%><!--반출구분--></td>
		<td align="center"><%=tax.get("ST2")%><!--구분코드--></td>	
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("TAX_COME_DT")))%><!--반출연월일--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NO")),29," ")%><!--과세물품명--></td>
		<td align="center">대<!--규격--></td>		
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NUM")),30," ")%><!--차대번호--></td>
		<td align="center">1<!--수량--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("CAR_FS_AMT"),13,"0")%><!--반출가격--></td>
		<td align="center"><%=tax.get("BK_122")%><!--친환경차감면세액--></td>
		<td align="center"><%=tax.get("CH_327")%><!--신차감면세액--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("SUR_AMT"),13,"0")%><!--과세표준--></td>
		<td align="center"><%=tax.get("TAX_RATE")%><!--세율--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("SPE_TAX_AMT"),13,"0")%><!--산출세액--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("EDU_TAX_AMT"),13,"0")%><!--교육세--></td>
		<td align="center">128-81-47957<!--반입처사업자등록번호--></td>
	</tr>
	<%	}
		}
	%>
</table>
</body>
</html>