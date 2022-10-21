<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=popup_fin_man_search_excel.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.partner.*, acar.admin.* "%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="pd_db" scope="page" class="acar.partner.PartnerDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
</script>

<body>
<%  
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");	
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String list_order = request.getParameter("list_order")==null?"":request.getParameter("list_order");
	
	String use_yn = request.getParameter("use_yn")==null?"Y":request.getParameter("use_yn");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	save_dt = ad_db.getMaxSaveDt("stat_debt");
	
	Vector vt =  new Vector();
	vt = se_dt.getServ_offList_20150416(s_kd, t_wd, gubun1, gubun2, sort_gubun, sort, "1", save_dt, list_order);
	int vt_size = vt.size();
	
	int vc_size = 0;
	String newyn = "";
	long jan_tot_amt = 0;
%>
<table border="1" cellspacing="0" cellpadding="0" width=1220>
	<tr> 
    	<td colspan="9" align="center">
    		<font face="돋움" size="4" ><b>거래금융기관</b></font>
      	</td>
  	</tr>
  	<tr align="center"> 
	    <td width='50' style="font-size : 9pt;">연번</td>
    	<td width='100' style="font-size : 9pt;">관리구분</td>
    	<td width='100' style="font-size : 9pt;">상호</td>
    	<td width='100' style="font-size : 9pt;">지점구분</td>
    	<td width='100' style="font-size : 9pt;">전화번호</td>
    	<td width='150' style="font-size : 9pt;">거래내용</td>
		<td width='150' style="font-size : 9pt;">최초등록일</td>
		<td width='100' style="font-size : 9pt;">변경등록일</td>   
		<td width='150' style="font-size : 9pt;">대출거래잔액<br>(<%=AddUtil.ChangeDate2(String.valueOf(save_dt))%>)</td>  
   	</tr>
<%if (vt_size > 0) {%>
	<%for (int i = 0; i < vt_size; i++) {%>
	<%
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		Hashtable seu = se_dt.getServ_emp_udt(String.valueOf(ht.get("OFF_ID")));
		String upt_dt = String.valueOf(seu.get("UPT_DT"));
		if (upt_dt.equals("null")) {
			upt_dt = "";
		}
	
		if (gubun1.equals("0001")) {
			Vector vc = se_dt.Count_serv_bc_item(String.valueOf(ht.get("OFF_ID")));
			vc_size = vc.size();
			for (int c = 0; c < vc_size; c++) {
				Hashtable hc = (Hashtable)vc.elementAt(c);
				newyn = String.valueOf(hc.get("NEWYN"));
			}
		}
	
		jan_tot_amt += Util.parseLong(String.valueOf(ht.get("OVER_MON_AMT")));
	%>
  	<tr> 
	    <td width='50' align='center' style="font-size : 8pt;"><%=i+1%>&nbsp;</td>
	    <td width='100' align='center' style="font-size : 8pt;"><%=ht.get("NM_CD")%>&nbsp;</td>	
	    <td width='100' align='center' style="font-size : 8pt;"><%=AddUtil.subData(String.valueOf(ht.get("OFF_NM")),10)%>&nbsp;</td>
	    <td width='100' align='center' style="font-size : 8pt;"><%if(ht.get("BR_ID").equals("S1")){%>본점<%}else if(ht.get("BR_ID").equals("B1")){%>지점<%}%>&nbsp;</td>   
		<td width='100' align='center' style="font-size : 8pt;"><%=ht.get("OFF_TEL")%>&nbsp;</td>   
	    <td width='150' align='center' style="font-size : 8pt;"><%=ht.get("NOTE")%>&nbsp;</td>
		<td width='150' align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%>&nbsp;</td>
		<td width='100' align='center' style="font-size : 8pt;"><%=AddUtil.ChangeDate2(upt_dt)%>&nbsp;</td>
	    <td width='150' align='right' style="font-size : 8pt;"><%=AddUtil.parseDecimal2(String.valueOf(ht.get("OVER_MON_AMT")))%>&nbsp;</td>
    </tr>    
	<%}%>
	<tr>
		<td width='850' align='center' colspan="8" style="font-size : 8pt;">대출거래잔액 합계</td>
		<td width='150' align='right' style="font-size : 8pt;"><%=Util.parseDecimal(jan_tot_amt)%>&nbsp;</td>
	</tr>
<%}%>
</table>
</body>
</html>
