<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	
	if(!gubun4.equals("3")){
		s_dt = "";
		e_dt = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;		
	
	
	LoginBean login = LoginBean.getInstance();
	if(t_wd.equals("") && s_kd.equals("4"))		t_wd = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;
		
		var start_dt =fm.s_dt.value;
		var end_dt =fm.e_dt.value;
		var search_text =fm.t_wd.value;
		
		if (fm.gubun4.value == "3") {
			if (start_dt.trim() == "" && end_dt.trim() == "") {
				alert("기간검색시 시작일과 종료일을 모두 입력해 주세요.");
				return;
			}
		}
		
		if (fm.gubun4.value == "" || fm.gubun4.value == "3") {
			if (search_text.trim() == "") {
				alert("전체 또는 기간 검색시 검색어를 입력해 주세요.");
				return;
			}
		}				
		
		fm.action = "esti_mng_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	

	//디스플레이 타입
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //기간
			esti.style.display 	= '';
		}else{
			esti.style.display 	= 'none';
		}
	}

	
//-->
</script>
</head>
<body>
<form action="./esti_mng_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>신차견적서관리 (최근3개월이내)</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"> 
            <table border=0 cellpadding=0 cellspacing=1 width="100%">
                <tr> 
                    <td width="18%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_g_gj.gif align=absmiddle>&nbsp;
                        <select name="gubun1">
                            <option value="">전체</option>
                            <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>FMS</option>
                            <option value="7" <%if(gubun1.equals("7"))%>selected<%%>>FMS-삭제</option>
                            <!--
                            <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>홈페이지</option>
                            <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>상담요청</option>
                            <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>고객서비스</option>				
                            <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>주요차종</option>
                            <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>장기대여</option>
                            -->
                        </select> 
                    </td>
                    <td width="16%"><img src=/acar/images/center/arrow_dygb.gif align=absmiddle>&nbsp;
                        <select name="gubun2">
                            <option value="">전체</option>
                            <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>리스플러스</option>
                            <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>장기렌트</option>
                        </select> 
                    </td>
                    <td width="14%"><img src=/acar/images/center/arrow_dybs.gif align=absmiddle>&nbsp;
                        <select name="gubun3">
                            <option value="">전체</option>
                            <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>일반식</option>
                            <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>기본식</option>
                        </select> 
                    </td>
                    <td width="16%"><img src=/acar/images/center/arrow_jsj.gif align=absmiddle>&nbsp;
                        <input type="text" name="gubun5" size="10" value="<%=gubun5%>" class=text> 
                    </td>                    
                    <td width=28%>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td><img src=/acar/images/center/arrow_day_gj.gif align=absmiddle>&nbsp;
                                    <select name="gubun4" onChange='javascript:cng_dt()'>                                        
                                        <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
					                    <option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전월</option>
                                        <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>당일</option>
					                    <option value="4" <%if(gubun4.equals("4"))%>selected<%%>>전일</option>
                                        <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>
                                    </select>
                                </td>
                                <td id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>''<%}%>">
                                	<input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                	~ 
                                	<input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                </td>                                
                            </tr>
                        </table> 
                    </td>
                    <td align="right">&nbsp;</td>
                </tr>
                <tr> 
                    <td colspan='6'>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                                    <select name="s_kd">                                        
                                        <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>차종</option>                                    
                                        <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>고객명</option> 
                                        <option value="6" <%if(s_kd.equals("6"))%>selected<%%>>사업자/생년월일</option> 
                                        <option value="7" <%if(s_kd.equals("7"))%>selected<%%>>전화번호/FAX</option>                                     
                                        <option value="8" <%if(s_kd.equals("8"))%>selected<%%>>이메일주소</option> 
                                        <option value="5" <%if(s_kd.equals("5"))%>selected<%%>>일련번호</option>
                                        <option value="9" <%if(s_kd.equals("9"))%>selected<%%>>견적담당자</option>
                                    </select> 
                                    &nbsp;<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class=text onKeyDown="javasript:EnterDown()"> 
                                    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

