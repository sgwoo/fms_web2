<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	
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
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트_영업팀
	int user_size = users.size();
	
	LoginBean login = LoginBean.getInstance();
	if(t_wd.equals("") && s_kd.equals("4"))		t_wd = login.getCookieValue(request, "acar_id");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
	//조회
	function search(){
		var fm = document.form1;
		var link = document.getElementById("submitLink");
		link.setAttribute('href',"javascript:alert('데이터 로딩 중입니다. 잠시만 기다려주세요');");
		
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //작성자,상담자
			fm.t_wd.value = fm.reg_id.options[fm.reg_id.selectedIndex].value;		
		}
		fm.action = "esti_spe_hp_sc.jsp";
		fm.target = "c_foot";
		fm.submit();
		
		
	}
	function EnterDown(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	//디스플레이 타입
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '2'||fm.s_kd.options[fm.s_kd.selectedIndex].value == '4'){ //작성자, 상담자
			td_input.style.display	= 'none';
			td_reg.style.display 	= '';
		}else{
			td_input.style.display	= '';
			td_reg.style.display 	= 'none';
			fm.t_wd.value = '';
		}
	}	
	//디스플레이 타입
	function cng_dt(){
		var fm = document.form1;
		if(fm.gubun4.options[fm.gubun4.selectedIndex].value == '3'){ //기간
			esti.style.display 	= '';
			fm.esti_m_dt.value		= '';
			esti_m_dt.style.display = 'none';
		}else{
			esti.style.display 	= 'none';
		}
	}
	
	
</script>
</head>
<body>
<form action="./esti_spe_hp_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>스마트 견적관리</span></span></td>
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
            <table border=0 cellspacing=1 cellpadding=0 width="100%">
                <tr> 
                    <td colspan="2">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_ssjh.gif align=absmiddle>&nbsp;
                                    <select name="gubun4" onChange='javascript:cng_dt()'>
                                      <option value="">전체</option>
                                      <option value="4" <%if(gubun4.equals("4"))%>selected<%%>>당일</option>
                                      <option value="5" <%if(gubun4.equals("5"))%>selected<%%>>전일</option>
                                      <option value="1" <%if(gubun4.equals("1"))%>selected<%%>>당월</option>
                                      <option value="2" <%if(gubun4.equals("2"))%>selected<%%>>전월</option>
                                      <option value="3" <%if(gubun4.equals("3"))%>selected<%%>>기간</option>
                                  </select></td>
                                <td id='esti' style="display:<%if(!gubun4.equals("3")){%>none<%}else{%>''<%}%>"><input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                                ~
                                <input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                            </tr>
                        </table>  
                    </td>
                    <td width="13%"><img src=../images/center/arrow_sdyb.gif align=absmiddle>&nbsp;
                        <select name="esti_m" onChange='javascript:cng_input()'>
                            <option value="" <%if(esti_m.equals(""))%>selected<%%>>전체</option>
                            <option value="1" <%if(esti_m.equals("1"))%>selected<%%>>완료</option>
                            <option value="2" <%if(esti_m.equals("2"))%>selected<%%>>미상담</option>
                        </select></td>
                    <td width=27%>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_jj.gif align=absmiddle>&nbsp;
                                    <select name="gubun3">
                                      <option value="">전체</option>
                                      <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>본사</option>
                                      <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>부산지점</option>
                                      <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>대전지점</option>
									  <option value="7" <%if(gubun3.equals("7"))%>selected<%%>>인천지점</option>
									  <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>강남지점</option>
									  <option value="9" <%if(gubun3.equals("9"))%>selected<%%>>광화문지점</option>
									  <option value="10" <%if(gubun3.equals("10"))%>selected<%%>>송파지점</option>
									  <option value="8" <%if(gubun3.equals("8"))%>selected<%%>>수원지점</option>
									  <option value="5" <%if(gubun3.equals("5"))%>selected<%%>>광주지점</option>
									  <option value="6" <%if(gubun3.equals("6"))%>selected<%%>>대구지점</option>
									  <!--<option value="11" <%if(gubun3.equals("11"))%>selected<%%>>울산지점</option>-->
									</select>
								</td>
                            </tr>
                        </table> 
                    </td>
                    <td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g.gif align=absmiddle>&nbsp;
                                    <select name="gubun2">
                                      <option value="">전체</option>
                                      <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>장기계약</option>
                                      <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>월렌트</option>
									  <option>------------------</option>
									  <option value="5" <%if(gubun2.equals("5"))%>selected<%%>>PC-신차</option>
                                      <option value="6" <%if(gubun2.equals("6"))%>selected<%%>>PC-재리스</option>
									  <option value="7" <%if(gubun2.equals("7"))%>selected<%%>>PC-월렌트</option>
									  <option value="8" <%if(gubun2.equals("8"))%>selected<%%>>모바일-신차</option>
                                      <option value="9" <%if(gubun2.equals("9"))%>selected<%%>>모바일-재리스</option>
									  <option value="10" <%if(gubun2.equals("10"))%>selected<%%>>모바일-월렌트</option>
									  <option>------------------</option>
									  <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>PC용</option>
									  <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>모바일용</option>
									</select>
								</td>
                            </tr>
                        </table>
					</td>
                </tr>
                <tr> 
                    <td width=14%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                        <select name="s_kd" onChange='javascript:cng_input()'>
                            <option>전체</option>
                            <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>차명</option>
                            <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>작성자</option> 
                            <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>고객명</option> 
            				<option value="4" <%if(s_kd.equals("4"))%>selected<%%>>상담자</option>
							<option value="5" <%if(s_kd.equals("5"))%>selected<%%>>지점명</option>
                          </select> </td>
                    <td width=16%> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                                <td id=td_input <%if(s_kd.equals("2")||s_kd.equals("4")){%>style='display:none'<%}%> width="100%"> 
                                    <input type="text" name="t_wd" size="24" value="<%=t_wd%>" class=text onKeyDown="javasript:EnterDown()"> 
                                </td>
                                <td id=td_reg <%if(!(s_kd.equals("2")||s_kd.equals("4"))){%>style='display:none'<%}%>> 
                                    <select name="reg_id">
                                      <option value="">전체</option>
                                      <%	if(user_size > 0){
                							for (int i = 0 ; i < user_size ; i++){
                							Hashtable user = (Hashtable)users.elementAt(i);	%>
                                      <option value='<%=user.get("USER_ID")%>' <%if(t_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                                      <%		}
                						}		%>
                                    </select> 
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>&nbsp;</td>
        			<td>&nbsp;</td>
                    <td><a id="submitLink" href="javascript:search()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
	
</form>
</body>
</html>

