<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" scope="page" class="acar.esti_mng.EstiMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	int s_year = request.getParameter("s_year")==null?0:AddUtil.parseInt(request.getParameter("s_year"));
	int s_mon = request.getParameter("s_mon")==null?0:AddUtil.parseInt(request.getParameter("s_mon"));
	int s_day = request.getParameter("s_day")==null?0:AddUtil.parseInt(request.getParameter("s_day"));
	
	
		
	
	Vector users = EstiMngDb.getEstiMngIdList(br_id); //담당자 리스트
	int user_size = users.size();
	
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
		fm.action = "esti_end_sc.jsp";
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
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value == '7'){ //기간
			td_dt1.style.display 	= '';
			td_dt2.style.display 	= 'none';			
		}else{
			td_dt1.style.display 	= 'none';
			td_dt2.style.display 	= '';			
		}
	}						
//-->
</script>
</head>
<body>
<form action="./esti_end_sc.jsp" name="form1" method="POST" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>견적마감관리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>	
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td> 
            <table border=0 cellspacing=0 cellpadding=0 width="100%">
                <tr> 
                    <td width="18%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_ddj.gif align=absmiddle>&nbsp;&nbsp;&nbsp;
                      <select name="gubun1">
                        <option value="0" <%if(gubun1.equals("0"))%>selected<%%>>전체</option>
                        <%	if(user_size > 0){
        							for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("MNG_ID")%>' <%if(gubun1.equals(user.get("MNG_ID"))) out.println("selected");%>><%=user.get("MNG_NM")%></option>
                        <%		}
        						}		%>
                      </select>
                    </td>
                    <td width="17%"><img src=/acar/images/center/arrow_day_mg.gif align=absmiddle>&nbsp;&nbsp;&nbsp; 
                      <select name="gubun3" onChange='javascript:cng_dt()'>
                        <option value="">전체</option>
                        <option value="1" <%if(gubun3.equals("1"))%>selected<%%>>전전일</option>
                        <option value="2" <%if(gubun3.equals("2"))%>selected<%%>>전일</option>				
                        <option value="3" <%if(gubun3.equals("3"))%>selected<%%>>당일</option>
        <!--                <option value="4" <%if(gubun3.equals("4"))%>selected<%%>>익일</option>
                        <option value="5" <%if(gubun3.equals("5"))%>selected<%%>>명후일</option>-->
                        <option value="6" <%if(gubun3.equals("6"))%>selected<%%>>당월</option>
                        <option value="7" <%if(gubun3.equals("7"))%>selected<%%>>기간</option>
                      </select>
                    </td>
                    <td colspan=2 id=td_dt1 style="display:<%if(!gubun3.equals("7")){%>none<%}else{%>''<%}%>"> 
                      <input type="text" name="s_dt" size="11" value="<%=AddUtil.ChangeDate2(s_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                      ~ 
                      <input type="text" name="e_dt" size="11" value="<%=AddUtil.ChangeDate2(e_dt)%>" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>		
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_mgres.gif align=absmiddle>&nbsp;
                      <select name="gubun4">
                        <option value=""  <%if(gubun4.equals(""))%>selected<%%>>전체</option>
                        <option value="Y" <%if(gubun4.equals("Y"))%>selected<%%>>계약체결</option>
                        <option value="N" <%if(gubun4.equals("N"))%>selected<%%>>계약미체결</option>
                      </select>
                    </td>
                    <td><img src=/acar/images/center/arrow_g_mcg.gif align=absmiddle>&nbsp;
                      <select name="gubun5">
                        <option value=""  <%if(gubun5.equals(""))%>selected<%%>>전체</option>
                        <option value="1" <%if(gubun5.equals("1"))%>selected<%%>>타사계약</option>
                        <option value="2" <%if(gubun5.equals("2"))%>selected<%%>>자가용구입</option>
                        <option value="3" <%if(gubun5.equals("3"))%>selected<%%>>장기보류</option>
                        <option value="4" <%if(gubun5.equals("4"))%>selected<%%>>기타</option>
                      </select>
                    </td>
                    <td colspan="2"><img src=/acar/images/center/arrow_mcgsy.gif align=absmiddle>&nbsp;
                      <select name="gubun6">
                        <option value=""  <%if(gubun6.equals(""))%>selected<%%>>전체</option>
                        <option value="1" <%if(gubun6.equals("1"))%>selected<%%>>대여료</option>
                        <option value="2" <%if(gubun6.equals("2"))%>selected<%%>>선수금</option>
                        <option value="3" <%if(gubun6.equals("3"))%>selected<%%>>보증보험</option>
                        <option value="4" <%if(gubun6.equals("4"))%>selected<%%>>신용</option>
                        <option value="5" <%if(gubun6.equals("5"))%>selected<%%>>부가세</option>				
                        <option value="6" <%if(gubun6.equals("6"))%>selected<%%>>인지도</option>
                        <option value="7" <%if(gubun6.equals("7"))%>selected<%%>>기타</option>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
                      <select name="s_kd">
                        <option value="3" <%if(s_kd.equals("3"))%>selected<%%>>영업사원명</option>			  
                        <option value="1" <%if(s_kd.equals("1"))%>selected<%%>>거래처명</option>
                        <option value="2" <%if(s_kd.equals("2"))%>selected<%%>>차종</option>
                      </select>
                    </td>
                    <td> 
                      <input type="text" name="t_wd" size="24" value="<%=t_wd%>" class=text onKeyDown="javasript:EnterDown()"  style='IME-MODE: active'>
                    </td>
                    <td width=16%>&nbsp;</td>
                    <td><a href="javascript:search()"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
