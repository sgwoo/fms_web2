<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*, acar.user_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
			
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
		
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	
		
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));

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

	function save()
	{
		var fm = document.form1;	
		
		
		//if(confirm('2단계를 등록하시겠습니까?'))	
		//{		
			fm.target = 'i_no';
			
			fm.action = 'incom_reg_step2_a.jsp'
			fm.submit();
		//}		
	}	

		//목록
	function del_incom()
	{
		var fm = document.form1;
							
		if(confirm('삭제처리하시겠습니까?'))
		{		
			fm.target = 'i_no';
			fm.action = 'incom_reg_step2_del_a.jsp'
			fm.submit();
		}		
	
	}
	
	//목록
	function go_to_list(from_page)
	{
		var fm = document.form1;
		
		if (from_page == '/fms2/account/f_incom_frame.jsp' ) {
			fm.action = "./f_incom_frame.jsp";
		} else {
			fm.action = "./incom_r_frame.jsp";
		}
		
		fm.target = 'd_content';
		fm.submit();
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
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  <input type='hidden' name='bank_code2' 	value='<%=value[0]%>'>
  <input type='hidden' name='deposit_no2' 	value='<%=base.getBank_no()%>'>
  <input type='hidden' name='bank_name' 	value='<%=value[1]%>'>   
  <input type='hidden' name='ip_method' 	value='<%=base.getIp_method()%>'>
  <input type='hidden' name='card_cd' 	value='<%=base.getCard_cd()%>'>

 
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	 
   <tr> 
 		 <td align=right>&nbsp; 
 		  <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>
 		 <% if ( jung_type.equals("0") || jung_type.equals("2") ) { %>&nbsp;<a href="javascript:del_incom()"><img src="/acar/images/center/button_delete.gif" align=absmiddle border="0"></a><% } %>
 		 <% } %> 		 
 		 &nbsp;<a href="javascript:go_to_list('<%=from_page%>')"><img src="/acar/images/center/button_list.gif" align=absmiddle border="0"></a></td>
    </tr> 	
    
    <tr></tr><tr></tr><tr></tr>
    <tr>
        <td class=line2></tD>
    </tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>처리구분</td>
            <td colspan="3">&nbsp;
			  <input type="radio" name="p_gubun" value="1" checked >해당건처리 <!-- 해당건 처리 -->			
			  <input type="radio" name="p_gubun" value="3" >카드사입금처리   <!--카드사 미수금 ->카드사입금 처리 -->
			  <input type="radio" name="p_gubun" value="4" >보험사입금처리   <!--보험사입금 처리 -->	
			<% if ( user_id.equals("000063")) {%>
			  <input type="radio" name="p_gubun" value="2" >CMS    <!--CMS 처리 -->	            
			<% } %>
			</td>
          </tr>		  		    
        </table>
	  </td>
    </tr>
    
 	<tr>
      <td>&nbsp;</td>
    </tr>
      <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_next.gif align=absmiddle border=0></a></td>
	</tr>	
      <% } %>	
	<tr></tr><tr></tr><tr></tr>
		
	<tr><td>&nbsp;<font color=red>*</font> 해당건처리는 선수금, 대여료, 과태료, 면책금, 휴대차료 관련 입금처리<br>		
			&nbsp;<font color=red>*</font> 카드사입금처리는 카드로 결재한 경우 해당 결재건이 통장입금될때 입금처리<br>
			&nbsp;<font color=red>*</font> 보험사입금처리는 대여차량의 해지시 보험해지 환급금이 입금된 경우의 입금처리(보험담당자처리)<br>
			&nbsp;<font color=red>*</font> 페이엣 카드승인 취소인 경우는 금액마이너스... 현단계에서 다음버튼 클릭시 종료<br>	
       	&nbsp;<font color=red>*</font> 현장결재 카드승인 취소인 경우는 금액마이너스로 입금처리<br>		
         </td>
	</tr>
	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
set_init();
	
	function set_init(){
		var fm = document.form1;		
		
		if ( fm.ip_method.value  == '2' || fm.ip_method.value  == '3' ){ //카드 또는 현금
			fm.p_gubun[0].checked =true;
			fm.p_gubun[1].disabled=true;
			fm.p_gubun[2].disabled=true;
			
		}else {
			fm.p_gubun[0].disabled=false;
			fm.p_gubun[1].disabled=false;
			fm.p_gubun[2].disabled=false;
		}	
		
		
    }		
//-->
</script>
</body>
</html>
