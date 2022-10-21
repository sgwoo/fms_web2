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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	
	Vector taxs = t_db.getTaxExcelList_e2(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int tax_size = taxs.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("현재날짜 : "+ sdf.format(d));
		String filename = sdf.format(d)+"_개별소비세등록.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
	
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
		<td>친환경차감면세액</td>
		<td>노후차감면세액</td>
		<td>신차감면세액</td>
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
		if(tax_size > 0){
			for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
	%>
	<tr>
		<td align="center"><%="'01"%><!--반출구분--></td>
		<td align="center"><!--반출구분명--></td>
		<td align="center">200001<!--구분코드--></td>
		<td align="center"><!--구분코드명--></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("TAX_COME_DT")))%><!--반출연월일--></td>
		<td align="center"><%=tax.get("TAX_CODE")%><!--과세물품종류--></td>
		<td align="center"><!--과세물품종류명--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NO")),29," ")%><!--과세물품명--></td>
		<td align="center">대<!--규격--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NUM")),30," ")%><!--차대번호--></td>
		<td align="center">1<!--수량--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("CAR_FS_AMT"),13,"0")%><!--반출가격--></td>
		<td align="center"><%=tax.get("BK_122")%><!--친환경차감면세액--></td>
		<td align="center"><!--노후차감면세액--></td>
		<td align="center"><%=tax.get("CH_327")%><!--신차감면세액--></td>
		<td align="center"><!--과세표준--></td>
		<td align="center"><!--세율--></td>
		<td align="center"><!--세액--></td>
		<td align="center"><!--산출세액--></td>
		<td align="center"><!--면세미납세액--></td>
		<td align="center">0<!--공제세액--></td>
		<td align="center"><!--납부할세액--></td>
		<td align="center"><!--교육세--></td>
		<td align="center"><!--농어촌특별세--></td>
		<td align="center">128-81-47957<!--반입처사업자등록번호--></td>
		<td align="center">(주)아마존카<!--반입처상호--></td>
		<td align="center"><!--반출승인번호--></td>
		<td align="center"><%=(String)(tax.get("INIT_REG_DT"))%><!--반입연월일--></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("RENT_START_DT")))%><!--용도변경연월일--></td>
		<td align="center">Y<!--차종별용도(영업용구분)--></td>
		<td align="center"><!--잔존가치율--></td>
	</tr>
	<%	}
		}
	%>
</table>
</body>
</html>