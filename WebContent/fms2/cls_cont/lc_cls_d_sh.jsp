<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.user_mng.*, acar.admin.*"%>
<%@ page import="acar.insur.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">

<script language='javascript'>
<!--
	function search()
	{
	  //추후 데이타 많아지면
	   var fm = document.form1;	   	  
	  
	   if (fm.s_kd.value == '5' || fm.s_kd.value == '6' || fm.s_kd.value =='10') {
	     if (fm.s_kd.value == '5' &&  fm.gubun1[0].checked == true ) {
	       	alert("검색조건을 입력하셔야 합니다.")
	    	 	return;
	     }
	   	    
	   } else { 	     
	     if (fm.t_wd.value == '') {
	     	alert("검색조건을 입력하셔야 합니다.")
	     	return;
	     }
	     
	   } 
	    fm.target = "c_foot";
	   	fm.action = "/fms2/cls_cont/lc_cls_d_sc.jsp";
	    document.form1.submit();
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	function list_excel_cls(){
		fm = document.form1;
		if(fm.s_kd.value!='10'){
			alert('기안일자 기간만 조회가능합니다');
			return;
		}
		window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "list_excel";
		fm.action = "lc_cls_excel.jsp";
		fm.submit();
	}		
	//디스플레이 타입(검색) - 조회기간 선택시
	function cng_input1(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '10'){ //기간조회선택
			text_input.style.display	= 'none';
			text_input2.style.display	= '';
			fm.t_wd.value='';
			
		}else{
			text_input2.style.display	= 'none';
			text_input.style.display	= '';
			fm.st_dt.value='';
			fm.end_dt.value='';
		}
	}
//-->
</script>
</head>
<body onload="javascript:document.form1.t_wd.focus();" leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
		String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
%>
<form name='form1' action='/fms2/cls_cont/lc_cls_d_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 해지관리 > <span class=style5>해지정산문서처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>조건검색</span></td>
        <td align="right"></td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>
    <tr>
        <td colspan="2" class=line>
	        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=10%>검색조건</td>
                    <td width=30%>&nbsp;
            		    <select name='s_kd' onChange="javascript:cng_input1()">
                          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>상호 </option>
                          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>계약번호 </option>
                          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>차량번호 </option>
                          <option value='4' <%if(s_kd.equals("4")){%>selected<%}%>>기안자 </option>
                          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>해지일자 </option>
                    	  <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>전월 </option>
                    	  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>위약금감액결재자</option>
                    	  <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>기안일자</option>
                    	  <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>결재일자</option>
							 <option value='10' <%if(s_kd.equals("10")){%>selected<%}%>>기안일자 기간검색</option>                        
                        </select>     			    
        			    <span id="text_input2" style="display:none;"><input type="text" name="st_dt" size="10" value="<%=ad_db.getPreDay(AddUtil.getDate(4), 1)%>" class="text">
													~
													<input type="text" name="end_dt" size="10" value="<%=AddUtil.getDate(4)%>" class="text">
												</span>
        			    <span id="text_input" <%if(!st_dt.equals("")){%>style="display:none;"<%}%>><input type='text' name='t_wd' size='25' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'></span>
        		    </td>
        		    <td class=title width=10%>해지구분</td>
                    <td width=15%>&nbsp;
            		  <select name='andor'>
            		      <option value=''  <%if(andor.equals("")){ %>selected<%}%>>--전체--</option>
                          <option value='1' <%if(andor.equals("1")){%>selected<%}%>>계약만료</option>
                          <option value='2' <%if(andor.equals("2")){%>selected<%}%>>중도해약</option>
                          <option value='7' <%if(andor.equals("7")){%>selected<%}%>>출고전해지(신차)</option>
                          <option value='10' <%if(andor.equals("10")){%>selected<%}%>>개시전해지(재리스)</option>
                                                            
                      </select>
        			</td>		  	
                    <td class=title width=10%>결재여부</td>
                    <td width=15%>&nbsp;
            		    <input type="radio" name="gubun1" value=""  <%if(gubun1.equals(""))%>checked<%%>>
            			전체
            		    <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
            			미결
            		    <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
            			결재
        			</td>		  		  
                </tr>
            </table>
	    </td>
    </tr>  
    <tr align="right">
        <td colspan="2">
        <%if(nm_db.getWorkAuthUser("보험업무",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>
     			<a href="javascript:list_excel_cls();"><img src="/acar/images/center/button_bhex.gif"  border="0" align=absmiddle></a>
      		<%}%>
	     <a href="javascript:search();"><img src="/acar/images/center/button_search.gif"  border="0" align=absmiddle></a>
	    </td>
    </tr>
</table>
</form>
</body>
</html>
