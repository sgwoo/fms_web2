<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
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
	String jung_type = base.getJung_type();	
	
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
	
		//목록
	function upd_incom()
	{
		var fm = document.form1;
			
		if (toInt(parseDigit(fm.in_amt.value)) < 1 ) {
		 	 alert('금액을 확인하세요.');
			 return;
		}	
						
		if(confirm('금액수정하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_upd_a.jsp'
			fm.submit();
		}		
	
	}
	
		//목록
	function upd_incom1()
	{
		var fm = document.form1;
		
		if(fm.reason.value == ""){ alert("사유를 입력하세요!!."); return;}
								
		if(confirm('확인내역을 수정하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_upd1_a.jsp'
			fm.submit();
		}		
	
	}
		
			//카드사 수정
	function upd_card()
	{
		var fm = document.form1;
		
		if(fm.card_cd == ""){ alert("카드사를 선택하세요!!."); return;}
								
		if(confirm('수정하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_upd2_a.jsp'
			fm.submit();
		}		
	
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
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_scd_step2.jsp">
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>  
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=ip_amt%>">
  
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
            <td class=title width=10%>입금구분</td>
            <td width=13%>&nbsp;
			   <select name="ip_method" disabled>
		       	<option value='1' <%if(base.getIp_method().equals("1")) out.println("selected");%>>계좌</option>
		        <option value='2' <%if(base.getIp_method().equals("2")) out.println("selected");%>>카드</option>
		        <option value='3' <%if(base.getIp_method().equals("3")) out.println("selected");%>>현금</option>
		        <option value='4' <%if(base.getIp_method().equals("4")) out.println("selected");%>>CMS</option>
		        <option value='5' <%if(base.getIp_method().equals("5")) out.println("selected");%>>대체</option>
              </select>
            </td>  	
            <td class=title width=10%>입금일자</td>
            <td width=15%>&nbsp;<%=base.getIncom_dt()%>
            </td>
            <td class=title width=10%>입금총액</td>
            <td width=40% >&nbsp;
            	<input type='text' name="in_amt" value='<%=AddUtil.parseDecimalLong(base.getIncom_amt())%>' size="12" class='num' >원
            	 <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%> 
            	 <% if ( jung_type.equals("0") || jung_type.equals("2") ) { %>&nbsp;<a href="javascript:upd_incom()"><img src="/acar/images/center/button_modify.gif" align=absmiddle border="0"></a><% } %>
            	 <% } %>
            </td>						  
          </tr>		  
          <tr> 
  		 <td class=title width=10%>은행(카드사)</td>
<% if ( base.getIp_method().equals("1")) { %>  
            <td width=13%>&nbsp;<%=value[1]%></td>		
<% } else if ( base.getIp_method().equals("2")) { %> 	      
            <td width=13%>&nbsp;
               <select name="card_cd" >
                      	<option value='1' <%if(base.getCard_cd().equals("1")) out.println("selected");%>>BC</option>
		        <option value='2' <%if(base.getCard_cd().equals("2")) out.println("selected");%>>국민</option>
		        <option value='3' <%if(base.getCard_cd().equals("3")) out.println("selected");%>>신한</option>
		        <option value='4' <%if(base.getCard_cd().equals("4")) out.println("selected");%>>외환</option>
		        <option value='5' <%if(base.getCard_cd().equals("5")) out.println("selected");%>>롯데</option>
		        <option value='6' <%if(base.getCard_cd().equals("6")) out.println("selected");%>>현대</option>
		        <option value='7' <%if(base.getCard_cd().equals("7")) out.println("selected");%>>삼성</option>
		        <option value='8' <%if(base.getCard_cd().equals("8")) out.println("selected");%>>씨티</option>
		   <!--     <option value='9' <%if(base.getCard_cd().equals("9")) out.println("selected");%>>KCP</option>		   
		        <option value='10' <%if(base.getCard_cd().equals("10")) out.println("selected");%>>KCP2</option>		   -->
		       <option value='12' <%if(base.getCard_cd().equals("12")) out.println("selected");%>>페이엣</option>		    
		         <option value='11' <%if(base.getCard_cd().equals("11")) out.println("selected");%>>나이스</option>
		         <option value='13' <%if(base.getCard_cd().equals("13")) out.println("selected");%>>이노페이</option>		   
		                      
              </select> &nbsp;&nbsp;<a href="javascript:upd_card()"><img src="/acar/images/center/button_modify.gif" align=absmiddle border="0"></a>
           
            </td>	            
<% } else  { %>    	         
            <td width=13%>&nbsp;</td>	    
<% } %>                    			  
            <td class=title width=10%>계좌(카드)번호</td>
<% if ( base.getIp_method().equals("1")) { %>            
     	    <td width=15%>&nbsp;<%=base.getBank_no()%></td>        
<% } else if ( base.getIp_method().equals("2")) { %>            
     	    <td width=15%>&nbsp;<%=base.getCard_no()%></td>                
<% } else  { %>            
     	    <td width=15%>&nbsp;</td>             
<% } %>		
			<td class=title width=10%>적요</td>
            <td width=40% >&nbsp;<%=base.getRemark()%> 
            &nbsp;&nbsp;&nbsp;&nbsp;<input type='checkbox' name='re_chk' value='Y' <%if(base.getRe_chk().equals("Y")){%>checked<%}%> >확인
            &nbsp;&nbsp;<input type='text' name="reason" value='<%=base.getReason()%>' size='20' class='text' maxlength=40>            
             <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%> 
            &nbsp;&nbsp;<a href="javascript:upd_incom1()"><img src="/acar/images/center/button_modify.gif" align=absmiddle border="0"></a>
            <% } %>
            </td>	
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
