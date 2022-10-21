<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="bc_db" scope="page" class="acar.bad_cust.BadCustDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
-->
</script>
</head>

<body>
<%
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	
	if(!h_con.equals("")){
		Vector clients = rs_db.getClientList(rent_st, cust_st, h_con, h_wd);
		int client_size = clients.size();
%>
<form name='form1' action='./client_s_p.jsp' method='post'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='size' value='<%=client_size%>'>
<input type='hidden' name='cust_st' value='<%=cust_st%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(rent_st.equals("1") || rent_st.equals("9") ){%>
                <tr> 
                    <td width='5%' class='title'>연번</td>
                    <td width='5%' class='title'>구분</td>
                    <td class='title' width='5%'>등급</td>
                    <td class='title' width='20%'>상호</td>
                    <td class='title' width="15%">성명</td>
                    <td class='title' width='15%'>생년월일/사업자번호</td>                    
                    <td class='title' width='15%'>전화번호</td>
                    <td class='title' width='20%'>이메일</td>
                </tr>
                <%}else{%>
                <tr> 
                    <td width='5%' class='title'>연번</td>
                    <td width='5%' class='title'>구분</td>
                    <td class='title' width='5%'>등급</td>
                    <td class='title' width="20%">상호</td>
                    <td class='title' width='10%'>고객명</td>
                    <td class='title' width='15%' style='height:38'>생년월일/사업자번호</td>
                    <td class='title' width='10%'>차량번호</td>
                    <td class='title' width='12%'>차명</td>
                    <td class='title' width='18%'>이메일</td>
                </tr>
                <%}%>
                <%if(client_size > 0){
    				for(int i = 0 ; i < client_size ; i++){
    					Hashtable client = (Hashtable)clients.elementAt(i);
    					String gubun = (String)client.get("GUBUN");
    					String rank = (String)client.get("RANK");
    			%>
                <%		if(rent_st.equals("1") || rent_st.equals("9")){%>
                <tr> 
                    <td width='5%' align='center'><%=i+1%></td>
                    <td width='5%' align='center'> 
                      <%if(gubun.equals("l")){%>
                                          장기 
                        <%if(String.valueOf(client.get("USE_YN")).equals("N")){%><br>(해지)<%}%>                      
                      <%}else{%>
                                          단기 
                      <%}%>
                      <%if(!String.valueOf(client.get("SITE_ID")).equals("")){%><br>(지점)<%}%>                      
                    </td>
                    <td width='5%' align='center'> 
                      <%if(rank.equals("불량")){
        			     	String content = bc_db.getBadCustCont((String)client.get("SSN_NO"));%>
                            <a href="#" title="<%=content%>"><font color=red><%=rank%></font></a> 
                      <%}else{%>
                            <%=rank%> 
                      <%}%>
                    </td>
                    <td width='20%' align='center'><a href="javascript:parent.select('<%= client.get("GUBUN")%>','<%= client.get("RANK")%>','<%= client.get("CUST_ST")%>','<%= client.get("CUST_ID")%>','<%= client.get("CUST_NM")%>','<%= client.get("FIRM_NM")%>','<%= client.get("SSN")%>','<%= client.get("ENP_NO")%>','<%= client.get("LIC_NO")%>','<%= client.get("LIC_ST")%>','<%= client.get("TEL")%>','<%= client.get("M_TEL")%>','<%= client.get("ZIP")%>','<%= client.get("ADDR")%>','<%= client.get("CAR_NO")%>','<%= client.get("CAR_NM")%>','<%= client.get("CAR_MNG_ID")%>','<%= client.get("RENT_L_CD")%>','','<%= client.get("SITE_ID")%>','<%= client.get("MNG_ID")%>','<%= client.get("MNG_NM")%>','<%= client.get("VEN_CODE")%>','<%= client.get("CAR_ST")%>','<%= client.get("RENT_WAY")%>','<%= client.get("TWOMON_YN")%>','<%= client.get("RENT_START_DT")%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=client.get("FIRM_NM")%></span></a></td>
                    <td align='center' width=15%><span title='<%=client.get("CUST_NM")%>'><%=client.get("CUST_NM")%></span><span></br><%if(String.valueOf(client.get("AGE_SCP")).equals("1")){%><font color=red>21세</font><%}%></span></td>
                    <td width='15%' align='center'><%=client.get("ENP_NO")%><%if(String.valueOf(client.get("ENP_NO")).equals("")){%><%=AddUtil.ChangeEnpH(String.valueOf(client.get("SSN")))%><%}%></td>
                    <td align='center' width="15%"><%=client.get("TEL")%></td>
                    <td width='20%' align='center'><%=client.get("AGNT_EMAIL")%></td>
                </tr>
                <%		}else{%>
                <tr> 
                    <td width='5%' align='center'><%=i+1%></td>
                    <td width='5%' align='center'> 
                      <%if(gubun.equals("l")){%>
                      장기 
                      <%if(String.valueOf(client.get("USE_YN")).equals("N")){%><br>(해지)<%}%>
                      <%}else{%>
                      단기 
                      <%}%>
                    </td>
                    <td width='5%' align='center'> 
                      <%if(rank.equals("불량")){
        					String content = "";
        					if(rent_st.equals("1")) content = bc_db.getBadCustCont((String)client.get("SSN_NO"));%>
                      <a href="#" title="<%=content%>"><font color=red><%=rank%></font></a> 
                      <%}else{%>
                      <%=rank%> 
                      <%}%>
                    </td>
                    <td align='center' width="20%"><a href="javascript:parent.select('<%= client.get("GUBUN")%>','<%= client.get("RANK")%>','<%= client.get("CUST_ST")%>','<%= client.get("CUST_ID")%>','<%= client.get("CUST_NM")%>','<%= client.get("FIRM_NM")%>','<%= client.get("SSN")%>','<%= client.get("ENP_NO")%>','<%= client.get("LIC_NO")%>','<%= client.get("LIC_ST")%>','<%= client.get("TEL")%>','<%= client.get("M_TEL")%>','<%= client.get("ZIP")%>','<%= client.get("ADDR")%>','<%= client.get("CAR_NO")%>','<%= client.get("CAR_NM")%>','<%= client.get("CAR_MNG_ID")%>','<%= client.get("RENT_L_CD")%>','<%= client.get("AGE_SCP")%>','<%= client.get("SITE_ID")%>','<%= client.get("MNG_ID")%>','<%= client.get("MNG_NM")%>','<%= client.get("VEN_CODE")%>','<%= client.get("CAR_ST")%>','<%= client.get("RENT_WAY")%>','<%= client.get("TWOMON_YN")%>','<%= client.get("RENT_START_DT")%>','<%= client.get("MAINT_ST_DT")%>','<%= client.get("MAINT_END_DT")%>','<%= client.get("CAR_END_DT")%>','<%= client.get("TEST_ST_DT")%>','<%= client.get("TEST_END_DT")%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 10)%></span></a></td>
                    <td width='10%' align='center'><span title='<%=client.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CUST_NM")), 6)%></span><span></br><%if(String.valueOf(client.get("AGE_SCP")).equals("1")){%><font color=red>21세</font><%}%></span></td>
                    <td width='15%' align='center'><%=client.get("ENP_NO")%></td>
                    <td width='10%' align='center'><%=client.get("CAR_NO")%>
                    <%if(String.valueOf(client.get("CAR_NO")).equals("")){%><%=client.get("RENT_L_CD")%>
                    <%if(!String.valueOf(client.get("RENT_DT")).equals("")&&!String.valueOf(client.get("RENT_DT")).equals("null")){%><font color=red><%=client.get("RENT_DT")%></font><%}%>
                    <%}%>
                    </td>
                    <td align='center' width="12%"><span title='<%=client.get("CAR_NM")+" "+client.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(client.get("CAR_NM")+" "+client.get("CAR_NAME")), 8)%></span></td>
                    <td width='18%' align='center'><%=client.get("AGNT_EMAIL")%></td>
                </tr>
              <%		}%>
              <%}
    			}else{	%>
                <tr> 
                    <td colspan="9" align='center'>등록된 데이타가 없습니다</td>
                </tr>
              <%	}%>
            </table>
	    </td>
	</tr>
</table>
<%	}%>
</form>
</body>
</html>
