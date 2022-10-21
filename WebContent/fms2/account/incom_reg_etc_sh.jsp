<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "13");
	
			
	String ven_code = "";
	String ven_name = "";

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	
	
	function search_insidebank()
	{
		fm = document.form1;			
						
		window.open("/fms2/account/shinhan_erp_demand_inside_etc.jsp?ven_code = "+fm.n_ven_code.value, "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	
		//거래처조회하기
	function search(idx){
		var fm = document.form1;	
		var t_wd;
		if(fm.n_ven_name.value != ''){	fm.t_wd.value = fm.n_ven_name.value;		}
		else{ 							alert('조회할 거래처명을 입력하십시오.'); 	fm.n_ven_name.focus(); 	return;}
		window.open("vendor_list.jsp?idx="+idx+"&t_wd="+fm.t_wd.value, "VENDOR_LIST", "left=350, top=150, width=700, height=400, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function search_enter(idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') search(idx);
	}	
	
	//디스플레이 타입
	function cls_display(){
		var fm = document.form1;
				
		if ( fm.n_ven_code.value == '006371'  ||  fm.n_ven_code.value == '114764'   || fm.n_ven_code.value == '006328'  || fm.n_ven_code.value == '005481' || fm.n_ven_code.value == '608892' || fm.n_ven_code.value == '995578' || fm.n_ven_code.value == '608959' || fm.n_ven_code.value == '108454'  || fm.n_ven_code.value == '996115'  || fm.n_ven_code.value == '996126' || fm.n_ven_code.value == '107776' ||  fm.n_ven_code.value == '028641' ||  fm.n_ven_code.value == '007812'  ) { 
	                      
			if (fm.ip_acct.value == '15' ) {  // 선수금에서 미수금으로 계정변경 - 20190917
				 fm.remark.value = "자체출고캐쉬백수익";			
			} else {
				 fm.remark.value = "";		
			}				
		}			
			
	}	
	
//-->
</script> 

</head>
<body leftmargin="15">
<form name='form1' action='incom_reg_etc_sc.jsp' target='c_foot' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='bank_code2' value=''>     
  <input type='hidden' name='deposit_no2'  value=''>    
  <input type='hidden' name='bank_name' 	value=''> 
 <input type="hidden" name="t_wd" value="">  
 <input type="hidden" name="ip_method" value="1">  
 <input type="hidden" name="incom_gubun" value="2">  

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						입금원장등록 [합산]</span></span></td>
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
            <td class=title width=13%>입금일자</td>
            <td>&nbsp;
			  <input type='text' name='incom_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.getDate()%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
			   &nbsp;<a href='javascript:search_insidebank()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
		 	<!--  &nbsp;<a href='javascript:search_shinhan_ebank()' onMouseOver="window.status=''; return true" title="클릭하세요">비즈파트너</a> -->
	 
			   </td>
          </tr>		
           <tr> 
		            <td class=title width=13%>거래처</td>
		            <td >&nbsp;
		            	<input name="n_ven_name" type="text" class="text" value="<%=ven_name%>" size="35" style='IME-MODE: active' onKeyDown="javasript:search_enter(1)">
						&nbsp;&nbsp;&nbsp;* 네오엠코드 : &nbsp;	        
						<input type="text" readonly name="n_ven_code" value="<%=ven_code%>" class='whitetext' >
					       	<input type="hidden" name="n_ven_nm_cd"  value="">&nbsp;			
						<a href="javascript:search(1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a> 				
			 		</td>	         
           </tr>	
           
            <tr> 
		            <td class=title width=13%>항목</td>
		            <td  >&nbsp;
		            <select name='ip_acct'  onChange='javascript:cls_display()'>
			              <option value=''>-선택-</option>
		                      <option value='0'>선수금</option>		         
		                      <option value='15'>미수금</option>           
		                      <option value='3'>고객환불</option>
		                      <option value='4'>면책금</option>
		                      <option value='5'>가수금</option>		                      
		                      <option value='6'>카드캐쉬백</option>
		                      <option value='17'>제조사캐쉬백</option>
		                      <option value='7'>세금과공과</option>
		                      <option value='8'>외상매출금</option>
		                      <option value='9'>지급수수료</option>
		                      <option value='10'>미지급금</option>    
		                      <option value='11'>가지급금</option>    
		                      <option value='12'>잡이익</option>  
		                      <option value='13'>과태료미수금</option>     
		                      <option value='14'>선급금</option>  		              
		                      <option value='16'>단기차입금</option>      
		                      <option value='18'>이자수익</option>     
		                     <option value='1'>계약승계수수료</option>
		                      <option value='2'>채권추심수수료</option>        
		                       <option value='19'>사고수리비</option>       
		                       <option value='20'>운반비</option>                                   
                   	 </select>
                   </td> 
               </tr>
               <tr>
               <td class=title width=13%>대/차변</td>
		            <td>&nbsp;
			  			<input type="radio" name="acct_gubun" value="C" checked >대변 
			  			<input type="radio" name="acct_gubun" value="D" >차변 
                   </td>
                 </tr>		   
                <tr> 
		            <td class=title width=13%>특이사항</td>
		            <td  >&nbsp;
		                <input name="remark" type="text"   class="text" size="80" >	
		      	&nbsp;&nbsp;
		      	     </td> 
		      	  </tr>   
                       	 
        </table>
	  </td>
    </tr>
   
    <tr>
      <td>&nbsp;</td>
    </tr>
   
   
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
