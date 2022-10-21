<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.car_service.*, acar.con_ser.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "04");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	ConSerDatabase cs_db = ConSerDatabase.getInstance();
	
	Vector ser_scd = cs_db.getServiceScd(m_id, l_cd, c_id);
	int ser_scd_size = ser_scd.size();
	
	int total_amt1 = 0;
	int total_amt2 = 0;
	int total_amt3 = 0;
%>
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
                    <td align='center' width=4%><%=i+1%></td>
                    <td align='center' width=9%><%=bean.getServ_dt()%></td>			
                    <td align='center' width=8%><a href="javascript:parent.ServiceDisp('<%=bean.getServ_id()%>', '<%=bean.getServ_st()%>', '<%=bean.getOff_id()%>')"><%=bean.getServ_st()%></a></td>
                    <td align='center' width=7%>
        			  <%if(bean.getChecker().substring(0,1).equals("0")){%>
        			  <%=c_db.getNameById(bean.getChecker(), "USER")%>
        			  <%}else{%>
        			  <%=bean.getChecker()%>			  
        			  <%}%>			
        			</td>
                    <td align='center' width=15%>&nbsp;<span title='<%=bean.getOff_nm()%>'><%=Util.subData(String.valueOf(bean.getOff_nm()), 8)%></span></td>
                    <td align='right' width=8%><%=Util.parseDecimal(bean.getTot_dist())%>km&nbsp;</td>
                    <td align='right' width=11%><%=Util.parseDecimal(bean.getRep_amt())%>원&nbsp;</td>
                    <td align='right' width=10%><%=Util.parseDecimal(bean.getDc())%>원&nbsp;</td>
                    <td align='right' width=11%><%=Util.parseDecimal(bean.getTot_amt())%>원&nbsp;</td>
                    <td align='center' width=9%> 
                      <input type='text' name='set_dt' size='11' value='<%=bean.getSet_dt()%>' class='text' onBlur='javascript:this.value=ChangeDate(this.value)'>
                    </td>
                    <td align='center' width=8%>
        			<%if(br_id.equals("S1") || br_id.equals(brch_id)){%>
        			<%	if(bean.getSet_dt().equals("")){ //미입금%> 
                    <%		if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <!--<a href="javascript:parent.change_scd('p', 'Y', '<%=i%>', '<%=bean.getAccid_id()%>', '<%=bean.getServ_id()%>')"><img src=../images/center/button_in_modify.gif align=absmiddle border=0></a>--> 
                    <%		}%>
        			<%	}else{%> 			  
                    <%		if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                      <a href="javascript:parent.change_scd('u', 'N', '<%=i%>', '<%=bean.getAccid_id()%>', '<%=bean.getServ_id()%>')"><img src=../images/center/button_in_cg.gif align=absmiddle border=0></a> 
                    <%		}%>
        			<%	}%>
        			<%}%>
                    </td>
                </tr>
<%					total_amt1 = total_amt1 + bean.getRep_amt();
					total_amt2 = total_amt2 + bean.getDc();
					total_amt3 = total_amt3 + bean.getTot_amt();
		}%>
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">합계</td>					
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>					
        			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt1)%>원&nbsp;</td>
        			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt2)%>원&nbsp;</td>
        			<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt3)%>원&nbsp;</td>										
                    <td class="title">&nbsp;</td>					
                    <td class="title">&nbsp;</td>								
                </tr>

<%	}else{%>
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
