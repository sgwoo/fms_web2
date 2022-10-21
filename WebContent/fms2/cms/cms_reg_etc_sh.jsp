<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>


<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
		//로그인ID&영업소ID&권한
	if(user_id.equals("")) 	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
		
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003");
	int bank_size = banks.length;

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
	
		//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		
	//	fm.go_target.value = "c_foot";
	
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=yes,resizable=yes,width=850,height=600,left=150,top=50');		
		fm.action = "s_cont_multi.jsp";		
		fm.target = "search_open";
		fm.submit();		
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
	

	
//-->
</script> 

</head>
<body leftmargin="15">
<form name='form1' action='incom_reg_etc_sc.jsp' target='c_foot' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>

  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
				   <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 입금관리 > <span class=style5>CMS 변경요청등록</span></span></td>
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
            <td class=title width=13%>상호</td>
            <td>&nbsp;
            <input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>
			   &nbsp;<a href='javascript:SearchopenBrWindow()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
		 	 
			   </td>
          </tr>
          
           <tr> 
		            <td class=title width=15%>거래은행</td>
		            <td>&nbsp;
                        <select name='cms_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];	%>
                        <option value='<%= bank.getNm()%>' ><%=bank.getNm()%></option>
                           <%			}%>
                        <%		
        					}%>
                      </select>
                    </td>      
           </tr>	
           
            <tr>
               <td class=title width=13%>계좌번호</td>
		            <td>&nbsp;
			  			   <input type='text' name='cms_acc_no' size='20' class='text'   >
                   </td>
            </tr>		   
            <tr>
               <td class=title width=13%>예금주</td>
		            <td>&nbsp;
			  			<input type='text' name='cms_dep_nm' size='20' class='text'  style='IME-MODE: active'>
                   </td>
            </tr>	
            <tr>
               <td class=title width=13%>예금주 생년월일/사업자번호</td>
		         <td>&nbsp;
			  		<input type='text' name='cms_dep_ssn' size='15' class='text' >
                </td>
            </tr>	   
                        
      	 </table>
        </td>
    </tr>
    
  
    <tr> 
       <td colspan='2'>&nbsp;&nbsp;<font color="blue">※ 파일 복사처리가 가능하도록 먼저 1건이상  통장사본, CMS동의서를 스캔등록한후 진행하세요. 스캔등록일과 변경신청일이 같아야 처리됩니다.</font></td>
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
