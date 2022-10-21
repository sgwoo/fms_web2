<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head><title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//디스플레이 타입
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun2.options[fm.gubun2.selectedIndex].value == '5'){ //기간
			td_dt1.style.display 	= '';
			td_dt2.style.display 	= 'none';			
		}else{
			td_dt1.style.display 	= 'none';
			td_dt2.style.display 	= '';			
		}
	}			
	
	function search(){
		var fm = document.form1;
		if(fm.st_dt.value != ''){ fm.st_dt.value = ChangeDate3(fm.st_dt.value);	}
		if(fm.end_dt.value != ''){ fm.end_dt.value = ChangeDate3(fm.end_dt.value);	}
		if(fm.st_dt.value !='' && fm.end_dt.value==''){ fm.end_dt.value = fm.st_dt.value; }		
		fm.submit()
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//라벨스티커출력	
	function select_label(){
		var fm = parent.c_foot.i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("라벨 인쇄할 공문을 선택하세요.");
			return;
		}	
		alert('라벨용지 남은것 사용시 갯수 확인하여 남은 갯수 만큼 체크하여 인쇄하시기 바랍니다.');
		fm.doc_cnt.value = cnt;
		fm.target = "_blank";
		fm.action = "label_print_select.jsp?";
		fm.submit();	
		
	}			
	
	//엑셀다운로드	
	function select_excel(){
		var fm = parent.c_foot.i_no.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("다운로드할 공문을 선택하세요.");
			return;
		}	
		fm.doc_cnt.value = cnt;
		fm.target = "_blank";
		fm.action = "settle_doc_mng_excel.jsp";
		fm.submit();	
		
	}			
		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='settle_doc_mng_sc.jsp' target='c_foot' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5>최고장발송대장</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <tr>
	  <td>			
        <table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
            <td width='15%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_shij.gif align=absmiddle>&nbsp;
              <select name="gubun2" onChange='javascript:cng_dt()'>
                <option value="">전체</option>
                <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>전전일</option>
                <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>전일</option>
                <option value="7" <%if(gubun2.equals("7"))%>selected<%%>>전월</option>
                <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>당일</option>
                <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>당월</option>
                <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>기간</option>
              </select>
            </td>
            <td width="20%"> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="200" id=td_dt1 style="display:<%if(!gubun2.equals("5")){%>none<%}else{%>''<%}%>"> 
                    <input type="text" name="st_dt" size="11" value="<%=AddUtil.ChangeDate2(st_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    ~ 
                    <input type="text" name="end_dt" size="11" value="<%=AddUtil.ChangeDate2(end_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                  </td>
                  <td width="200" id=td_dt2 style="display:<%if(gubun2.equals("5")){%>none<%}else{%>''<%}%>">&nbsp; 
                  </td>
                </tr>
              </table>
            </td>
            <td width="60%">&nbsp; </td>
          </tr>
          <tr> 
            <td colspan="3">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
              <select name="s_kd">
                <option value=""  <%if(s_kd.equals("")){%> selected <%}%>>전체</option>
                <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
                <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
              </select>
              &nbsp;&nbsp;<input type="text" name="t_wd" size="30" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()">
            </td>
           
          </tr>
          
          <tr> 
            <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_jg.gif align=absmiddle>&nbsp;
             <input type="radio" name="gubun1" value="1" <%if(gubun1.equals("1"))%>checked<%%>>
                      채권 
             <input type="radio" name="gubun1" value="2" <%if(gubun1.equals("2"))%>checked<%%>>
                      법무     
				  
					  </td>
                      
            <td>
            	<a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a>
           		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           		<!--라벨스티커출력-->
				<a href="javascript:select_label();" title="라벨출력"><img src="/acar/images/center/button_print_label.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
           		<!--엑셀다운로드-->
				<a href="javascript:select_excel();" title="엑셀다운"><img src="/acar/images/center/button_excel.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
			</td>
          </tr>
          
        </table>
      </td>
	</tr>
</table>
</form>
</body>
</html>
