<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
		
	String t_wd 	= request.getParameter("t_wd")==null? "":request.getParameter("t_wd");
	
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
															
	//입금거래내역 정보
	IncomBean base = in_db.getIncomBase(incom_dt, incom_seq);
	long ip_amt = base.getIncom_amt();
	String ip_method = base.getIp_method();
	
	String value[] = new String[2];
	StringTokenizer st = new StringTokenizer(base.getBank_nm(),":");
	int s=0; 
	while(st.hasMoreTokens()){
		value[s] = st.nextToken();
		s++;
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
			
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search_client();
	}
			
	//고객 조회
	function search_client()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/s_cont.jsp?incom_dt=<%=incom_dt%>&incom_seq=<%=incom_seq%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp", "CLIENT", "left=10, top=10, width=500, height=300, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	
	//지점/현장 조회
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}			
	//지점/현장 보기
	function view_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		if(fm.site_id.value == "")	{ alert("지점/현장을 먼저 선택하십시오."); return;}		
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/account/incom_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" >
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp">
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>  
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  		<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						입금원장등록 [3단계]</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr> 
    
    <tr> 
        <td class=line2></td>
    </tr>
    
    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
     	   <tr> 
            <td class=title width=13%>입금구분</td>
            <td width=17%>&nbsp;
			   <select name="ip_method" disabled>
		       	<option value='1' <%if(base.getIp_method().equals("1")) out.println("selected");%>>계좌</option>
		        <option value='2' <%if(base.getIp_method().equals("2")) out.println("selected");%>>카드</option>
		        <option value='3' <%if(base.getIp_method().equals("3")) out.println("selected");%>>현금</option>
		        <option value='4' <%if(base.getIp_method().equals("4")) out.println("selected");%>>CMS</option>
		        <option value='5' <%if(base.getIp_method().equals("5")) out.println("selected");%>>보증금</option>
              </select>
            </td>  	
            <td class=title width=13%>입금일자</td>
            <td width=17%>&nbsp;<%=base.getIncom_dt()%>
            </td>
            <td class=title width=10%>입금총액</td>
            <td width=30%>&nbsp;
            	<input type='text' name="in_amt" value='<%=AddUtil.parseDecimalLong(base.getIncom_amt())%>' size="12" class='whitenum' >원
            </td>						  
          </tr>		  
          <tr> 
  		 <td class=title width=13%>은행(카드사)</td>
<% if ( base.getIp_method().equals("1")) { %>  
            <td width=17%>&nbsp;<%=value[1]%></td>		
<% } else if ( base.getIp_method().equals("2")) { %> 	      
            <td width=17%>&nbsp;<%=base.getCard_nm()%></td>	            
<% } else  { %>    	         
            <td width=17%>&nbsp;</td>	    
<% } %>                    			  
            <td class=title width=13%>계좌(카드)번호</td>
<% if ( base.getIp_method().equals("1")) { %>            
     	    <td width=17%>&nbsp;<%=base.getBank_no()%></td>        
<% } else if ( base.getIp_method().equals("2")) { %>            
     	    <td width=17%>&nbsp;<%=base.getCard_no()%></td>                
<% } else  { %>            
     	    <td width=17%>&nbsp;</td>             
<% } %>		
			<td class=title width=10%>적요</td>
            <td width=30%>&nbsp;<%=base.getRemark()%></td>	
          </tr>		  
        		  
        </table>
	  </td>
    </tr>
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">

</script>
</body>
</html>
