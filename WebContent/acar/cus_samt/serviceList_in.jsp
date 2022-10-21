<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.car_service.*, acar.cus_samt.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusSamt_Database cs_db = CusSamt_Database.getInstance();
	
	Vector ser_scd = cs_db.getServiceScd(m_id, l_cd, c_id);
	int ser_scd_size = ser_scd.size();
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>


<form name='form1' action='' method='post' target=''>
<input type='hidden' name='tot_tm' value='<%=ser_scd_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	<td class='line'>			 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%	if(ser_scd_size>0){
		for(int i = 0 ; i < ser_scd_size ; i++){
			ServiceBean bean = (ServiceBean)ser_scd.elementAt(i);%>
          <tr> 
            <td align='center' width='5%'><%=i+1%></td>
            <td align='center' width='9%'><%=bean.getServ_dt()%></td>			
            <td align='center' width='8%'><a href="javascript:parent.ServiceDisp('<%=bean.getServ_id()%>', '<%=bean.getServ_st()%>', '<%=bean.getOff_id()%>')"><%=bean.getServ_st()%></a></td>
            <td align='center' width='7%'>
			  <%if(bean.getChecker().substring(0,1).equals("0")){%>
			  <%=c_db.getNameById(bean.getChecker(), "USER")%>
			  <%}else{%>
			  <%=bean.getChecker()%>			  
			  <%}%>			
			</td>
            <td align='left' width='14%'>&nbsp;<span title='<%=bean.getOff_nm()%>'><%=Util.subData(String.valueOf(bean.getOff_nm()), 8)%></span></td>
            <td align='right' width='9%'><%=Util.parseDecimal(bean.getTot_dist())%>km&nbsp;</td>
            <td align='right' width='10%'><%=Util.parseDecimal(bean.getRep_amt())%>원&nbsp;</td>
            <td align='right' width='10%'><%=Util.parseDecimal(bean.getDc())%>원&nbsp;</td>
            <td align='right' width='10%'><%=Util.parseDecimal(bean.getTot_amt())%>원&nbsp;</td>
            <td align='center' width='10%'> 
              <input type='text' name='set_dt' size='12' value='<%=bean.getSet_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
            </td>
            <td align='center' width='8%'>
			<%if(bean.getSet_dt().equals("")){ //미입금%> 
              <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
              <a href="javascript:parent.change_scd('p', 'Y', '<%=i%>', '<%=bean.getAccid_id()%>', '<%=bean.getServ_id()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_cg.gif" align="absmiddle" border="0"></a> 
              <%}%>
			<%}else{%> 			  
              <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
              <a href="javascript:parent.change_scd('u', 'N', '<%=i%>', '<%=bean.getAccid_id()%>', '<%=bean.getServ_id()%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a> 
              <%}%>
			<%}%> 			  			  
            </td>
          </tr>
<%		}
	}else{%>
          <tr> 
            <td colspan='14' align='center'> 면책금스케줄이 없습니다 </td>
          </tr>
          <%	}%>
        </table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
