<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.grt_n{		background-color: #FAF4C0;	}
</style>
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
		Vector clients = rs_db.getClientListA(rent_st, cust_st, h_con, h_wd, ck_acar_id);
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
	    <td class='line'>		  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>����</td>
                    <td width='5%' class='title'>����</td>
                    <td class='title' width='5%'>���</td>
                    <td class='title' width="20%">��ȣ</td>
                    <td class='title' width='10%'>����</td>
                    <td class='title' width='15%' style='height:38'>����ڹ�ȣ<br>�������</td>
                    <td class='title' width='10%'>������ȣ</td>
                    <td class='title' width='12%'>����</td>
                    <td class='title' width='18%'>�̸���</td>
                </tr>            
              <%if(client_size > 0){
    				for(int i = 0 ; i < client_size ; i++){
    					Hashtable client = (Hashtable)clients.elementAt(i);
    					String gubun = (String)client.get("GUBUN");
    					String rank = (String)client.get("RANK");
    					
    					//������ �Աݿ��θ� fetch(20190925)
    					String rent_mng_id 	= String.valueOf(client.get("RENT_MNG_ID"));
    					String rent_l_cd 	  	= String.valueOf(client.get("RENT_L_CD"));
    					//�뿩�᰹����ȸ(���忩��)
    					int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
    					ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
    					
    					int grt_amt 			=	fees.getGrt_amt_s();	//������ �ݾ�
    					String grt_amt_yn = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0");	//������ ���Կ���
    					String grt_yn = ""; 
    					if(grt_amt == 0 ){	//�������� 0�ΰ�� -> ���Ա� �Աݿ��� üũ �޼���
    						grt_yn = "no_grt";
    					}else{	//�����ؾ��� �������� �ִ°�� 
    						if(grt_amt_yn.equals("�Ա�")||grt_amt_yn.equals("�ܾ�")){	//������ ���� 
    							grt_yn = "grt_y";	
    						}else{	//������ �̳���
    							grt_yn = "grt_n";
    						}
    					}
    			%>             
                <tr> 
                    <td width='5%' align='center' class="<%=grt_yn%>"><%=i+1%></td>
                    <td width='5%' align='center' class="<%=grt_yn%>"> 
                      <%if(gubun.equals("l")){%>
                      ��� 
                      <%if(String.valueOf(client.get("USE_YN")).equals("N")){%><br>(����)<%}%>
                      <%}else{%>
                      �ܱ� 
                      <%}%>
                    </td>
                    <td width='5%' align='center' class="<%=grt_yn%>"> 
                      <%=rank%> 
                    </td>
                    <td align='center' width="20%" class="<%=grt_yn%>">
                   	<%if(grt_yn.equals("grt_n")){%>
                    	<span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 10)%></span>
                    <%}else{%>
                    	<a href="javascript:parent.select('<%= client.get("GUBUN")%>','<%= client.get("RANK")%>','<%= client.get("CUST_ST")%>','<%= client.get("CUST_ID")%>','<%= client.get("CUST_NM")%>','<%= client.get("FIRM_NM")%>','<%= client.get("SSN")%>','<%= client.get("ENP_NO")%>','<%= client.get("LIC_NO")%>','<%= client.get("LIC_ST")%>','<%= client.get("TEL")%>','<%= client.get("M_TEL")%>','<%= client.get("ZIP")%>','<%= client.get("ADDR")%>','<%= client.get("CAR_NO")%>','<%= client.get("CAR_NM")%>','<%= client.get("CAR_MNG_ID")%>','<%= client.get("RENT_L_CD")%>','<%= client.get("AGE_SCP")%>','<%= client.get("SITE_ID")%>','<%= client.get("MNG_ID")%>','<%= client.get("MNG_NM")%>','<%= client.get("VEN_CODE")%>','<%=grt_yn%>')" onMouseOver="window.status=''; return true"><span title='<%=client.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("FIRM_NM")), 10)%></span></a>
                    <%}%>	
                    </td>
                    <td width='15%' align='center' class="<%=grt_yn%>"><span title='<%=client.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CUST_NM")), 6)%></span></br><span><%if(String.valueOf(client.get("AGE_SCP")).equals("1")){%><font color=red>21��</font><%}%></span></td>
                    <td width='15%' align='center' class="<%=grt_yn%>"><%=AddUtil.ChangeEnpH(String.valueOf(client.get("ENP_NO")))%></td>
                    <td width='10%' align='center' class="<%=grt_yn%>"><%=client.get("CAR_NO")%><%if(String.valueOf(client.get("CAR_NO")).equals("")){%><%= client.get("RENT_L_CD")%><%if(!String.valueOf(client.get("RENT_DT")).equals("")&&!String.valueOf(client.get("RENT_DT")).equals("null")){%><font color=red><%=client.get("RENT_DT")%></font><%}%><%}%></td>
                    <td align='center' width="12%" class="<%=grt_yn%>"><span title='<%=client.get("CAR_NM")+" "+client.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(client.get("CAR_NM")+" "+client.get("CAR_NAME")), 8)%></span></td>
                    <td width='13%' align='center' class="<%=grt_yn%>"><%=client.get("AGNT_EMAIL")%></td>
                </tr>
              <%		}%>
    	<%		}else{	%>
                <tr> 
                    <td colspan="9" align='center'>��ϵ� ����Ÿ�� �����ϴ�</td>
                </tr>
              <%	}%>
            </table>
	    </td>
	</tr>
</table>
<%}%>
</form>
</body>
</html>
