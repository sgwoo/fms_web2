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
                    <td width='5%' class='title'>연번</td>
                    <td width='5%' class='title'>구분</td>
                    <td class='title' width='5%'>등급</td>
                    <td class='title' width="20%">상호</td>
                    <td class='title' width='10%'>고객명</td>
                    <td class='title' width='15%' style='height:38'>사업자번호<br>생년월일</td>
                    <td class='title' width='10%'>차량번호</td>
                    <td class='title' width='12%'>차명</td>
                    <td class='title' width='18%'>이메일</td>
                </tr>            
              <%if(client_size > 0){
    				for(int i = 0 ; i < client_size ; i++){
    					Hashtable client = (Hashtable)clients.elementAt(i);
    					String gubun = (String)client.get("GUBUN");
    					String rank = (String)client.get("RANK");
    					
    					//보증금 입금여부를 fetch(20190925)
    					String rent_mng_id 	= String.valueOf(client.get("RENT_MNG_ID"));
    					String rent_l_cd 	  	= String.valueOf(client.get("RENT_L_CD"));
    					//대여료갯수조회(연장여부)
    					int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
    					ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
    					
    					int grt_amt 			=	fees.getGrt_amt_s();	//보증금 금액
    					String grt_amt_yn = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0");	//보증금 납입여부
    					String grt_yn = ""; 
    					if(grt_amt == 0 ){	//보증금이 0인경우 -> 선입금 입금여부 체크 메세지
    						grt_yn = "no_grt";
    					}else{	//납부해야할 보증금이 있는경우 
    						if(grt_amt_yn.equals("입금")||grt_amt_yn.equals("잔액")){	//보증금 납입 
    							grt_yn = "grt_y";	
    						}else{	//보증금 미납입
    							grt_yn = "grt_n";
    						}
    					}
    			%>             
                <tr> 
                    <td width='5%' align='center' class="<%=grt_yn%>"><%=i+1%></td>
                    <td width='5%' align='center' class="<%=grt_yn%>"> 
                      <%if(gubun.equals("l")){%>
                      장기 
                      <%if(String.valueOf(client.get("USE_YN")).equals("N")){%><br>(해지)<%}%>
                      <%}else{%>
                      단기 
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
                    <td width='15%' align='center' class="<%=grt_yn%>"><span title='<%=client.get("CUST_NM")%>'><%=AddUtil.subData(String.valueOf(client.get("CUST_NM")), 6)%></span></br><span><%if(String.valueOf(client.get("AGE_SCP")).equals("1")){%><font color=red>21세</font><%}%></span></td>
                    <td width='15%' align='center' class="<%=grt_yn%>"><%=AddUtil.ChangeEnpH(String.valueOf(client.get("ENP_NO")))%></td>
                    <td width='10%' align='center' class="<%=grt_yn%>"><%=client.get("CAR_NO")%><%if(String.valueOf(client.get("CAR_NO")).equals("")){%><%= client.get("RENT_L_CD")%><%if(!String.valueOf(client.get("RENT_DT")).equals("")&&!String.valueOf(client.get("RENT_DT")).equals("null")){%><font color=red><%=client.get("RENT_DT")%></font><%}%><%}%></td>
                    <td align='center' width="12%" class="<%=grt_yn%>"><span title='<%=client.get("CAR_NM")+" "+client.get("CAR_NAME")%>'><%=AddUtil.subData(String.valueOf(client.get("CAR_NM")+" "+client.get("CAR_NAME")), 8)%></span></td>
                    <td width='13%' align='center' class="<%=grt_yn%>"><%=client.get("AGNT_EMAIL")%></td>
                </tr>
              <%		}%>
    	<%		}else{	%>
                <tr> 
                    <td colspan="9" align='center'>등록된 데이타가 없습니다</td>
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
