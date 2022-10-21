<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="bme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="mme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="sme_bean" class="acar.user_mng.MenuBean" scope="page"/>
<jsp:useBean id="au_bean" class="acar.user_mng.AuthBean" scope="page"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String m_st = request.getParameter("m_st")==null?"01":request.getParameter("m_st");
	String m_st2 = request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_cd = request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String m_nm = request.getParameter("m_nm")==null?"":request.getParameter("m_nm");
	String url = request.getParameter("url")==null?"":request.getParameter("url");
	String note = request.getParameter("note")==null?"":request.getParameter("note");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	int count = 0;
	
	/***  권한 처리   */
    if(cmd.equals("ai")){
    	String code [] = null;
    	code = request.getParameterValues("m_cd");
    	
    		
	    Vector v = new Vector();
	    Throwable error = null;
	    if(code != null && code.length > 0){
	        for(int i=0; i<code.length; i++){
	            try{
		            String val [] = {code[i]};
	                v.addElement(val);
	            }catch(NoSuchElementException  nse){
	                error = nse;
	            }
	        }
	    }
	    umd.insertXmlAuthMa(user_id, m_st, m_st2, v);
    }

	MenuBean bme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "b"); //대메뉴리스트
	MenuBean mme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "m"); //중메뉴
	MenuBean sme_r [] = umd.getXmlMaMenuAll(m_st, m_st2, "s"); //소메뉴
	
	AuthBean au_r [] = umd.getXmlAuthMaAll(user_id, m_st, m_st2);
	
%>

<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function AuthReg(){
		var theForm = document.AuthForm;
		if(!confirm('권한부여하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "ai";
		theForm.submit();
	}

	function SMenuUp(){
		var theForm = document.AuthForm;
		var nm = theForm.m_nm.value;
		if(!confirm(nm + '을 수정하시겠습니까?')){
			return;
		}
		theForm.cmd.value = "u";
		theForm.submit();
	}

	function SMenuSearch(){
		var theForm = document.SMenuSearchForm;
		var theForm1 = document.AuthForm;
		theForm.m_st.value = theForm1.m_st.value;
		theForm.m_st2.value = theForm1.m_st2.value;
		theForm.submit();
	}
	
	function cng_display(idx){
		var fm = document.AuthForm;
		var size = toInt(fm.size.value);
		if(size ==1){
				fm.m_cd.options[idx].selected = true;
		}else{
			for(i=0; i<size; i++){
				fm.m_cd[i].options[idx].selected = true;
			}
		}
	}
	
   //직원조회
	function User_search()
	{
		var fm = document.SMenuCopyForm;
		fm.t_wd.value = fm.user_nm.value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');		
		fm.action = "user_search.jsp";
		fm.target = "User_search";
		fm.submit();		
	}	
	
	function CopyAuth(){
		var fm = document.SMenuCopyForm;
		if(fm.s_user_id.value == ''){ alert('권한복사 대상을 선택하십시오.'); return; }
		if(!confirm('권한복사하시겠습니까?')){
			return;
		}			
		fm.action="xml_user_auth_copy_a.jsp";
		fm.target="_blank";		
		fm.submit();
	}
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form action="./xml_user_auth_i.jsp" name="AuthForm" method="POST" >
<input type='hidden' name='size' value='<%=au_r.length%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><&nbsp;<%=c_db.getNameById(user_id, "USER")%>&nbsp;> <span class=style5>권한 등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr> 
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/pop/arrow_dmn.gif align=absmiddle>&nbsp; 
    		<select name="m_st" onChange="javascript:SMenuSearch()">
    			<option value="">선택</option>
				<%for(int i=0; i<bme_r.length; i++){
			        bme_bean = bme_r[i];%>
    			<option value="<%= bme_bean.getM_st() %>" <%if(m_st.equals(bme_bean.getM_st())){%>selected<%}%>><%= bme_bean.getM_nm() %></a>
				<%}%>
    		</select>
    		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    	    <img src=../images/pop/arrow_jmn.gif align=absmiddle>&nbsp; 
    		<select name="m_st2" onChange="javascript:SMenuSearch()">
    			<option value="">선택</option>
				<%for(int i=0; i<mme_r.length; i++){
        			mme_bean = mme_r[i];%>
    			<option value="<%= mme_bean.getM_st2() %>" <%if(m_st2.equals(mme_bean.getM_st2())){%>selected<%}%>><%= mme_bean.getM_nm() %></a>
				<%}%>
    		</select>    	
    	</td>
    </tr>
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="auth_st" value="0" onClick="javascript:cng_display(0)">접근제한
		 <input type="radio" name="auth_st" value="1" onClick="javascript:cng_display(1)">읽기
		 <input type="radio" name="auth_st" value="2" onClick="javascript:cng_display(2)">쓰기
		 <input type="radio" name="auth_st" value="3" onClick="javascript:cng_display(3)">수정
		 <input type="radio" name="auth_st" value="4" onClick="javascript:cng_display(4)">쓰기+수정
		 <input type="radio" name="auth_st" value="5" onClick="javascript:cng_display(5)">삭제
		 <input type="radio" name="auth_st" value="6" onClick="javascript:cng_display(6)">전체		 
		 </td>
    </tr>   
    <tr>
    	<td align=right><a href="javascript:AuthReg()"><img src=../images/pop/button_reg.gif border=0></a></td>
    </tr>    	
    <tr>
        <td class=line2></td>
    </tr> 
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width="100%">
                <tr>
                    <td class=title width="70">선택</td>
                    <td class=title>소메뉴</td>
                    <td class=title width="100">권한</td>
                </tr>
<%	for(int i=0; i<au_r.length; i++){
    	au_bean = au_r[i];%>
                <tr>                    
                    <td align=center>
                      <select name="m_cd">
                        <option value="<%=au_bean.getM_cd()%>0" <%if(au_bean.getAuth_rw().equals("0"))%>selected<%%>>0</option>
                        <option value="<%=au_bean.getM_cd()%>1" <%if(au_bean.getAuth_rw().equals("1") || au_bean.getAuth_rw().equals("W"))%>selected<%%>>1</option>
                        <option value="<%=au_bean.getM_cd()%>2" <%if(au_bean.getAuth_rw().equals("2"))%>selected<%%>>2</option>
                        <option value="<%=au_bean.getM_cd()%>3" <%if(au_bean.getAuth_rw().equals("3"))%>selected<%%>>3</option>
                        <option value="<%=au_bean.getM_cd()%>4" <%if(au_bean.getAuth_rw().equals("4"))%>selected<%%>>4</option>
                        <option value="<%=au_bean.getM_cd()%>5" <%if(au_bean.getAuth_rw().equals("5"))%>selected<%%>>5</option>
                        <option value="<%=au_bean.getM_cd()%>6" <%if(au_bean.getAuth_rw().equals("6"))%>selected<%%>>6</option>
                      </select>
                    </td>
                    <td align=center><%=au_bean.getM_nm()%></td>
                    <td align=center><%if(au_bean.getAuth_rw().equals("2")){%>읽기+쓰기<%}else if(au_bean.getAuth_rw().equals("3")){%>읽기+수정<%}else if(au_bean.getAuth_rw().equals("4")){%>읽기+쓰기+수정<%}else if(au_bean.getAuth_rw().equals("5")){%>읽기+삭제<%}else if(au_bean.getAuth_rw().equals("6")){%>전체<%}else if(au_bean.getAuth_rw().equals("0")){%>접근제한<%}else{%>읽기<%}%></td>
                </tr>
<%	}%>                
            </table>
        </td>
    </tr>
	<tr>
		<td style="font-size:8pt" >* 권한 = 0:접근제한, 1:읽기, 2:쓰기, 3:수정, 4:쓰기+수정, 5:삭제, 6:전체</td>	
	</tr>
</table>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="user_id" value="<%= user_id %>">
</form>

<form action="./xml_user_auth_i.jsp" name="SMenuSearchForm" method="post">
<input type="hidden" name="user_id" value="<%= user_id %>">
<input type="hidden" name="m_st" value="<%=m_st%>">
<input type="hidden" name="m_st2" value="<%=m_st2%>">
</form>

<form action="./xml_user_auth_copy_a.jsp" name="SMenuCopyForm" method="post">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/pop/arrow_ghbs.gif></td>
    </tr>   
    <tr>
        <td width=20>&nbsp;</td> 
        <td class='title'>사용자</td>
        <td colspan="3">&nbsp; 
        	<input name="user_nm" type="text" class="text"  size="10">    
        	<input name="s_user_id" type="text" class="fix"  size="5" readonly>                       
            <input type="hidden" name="idx" value="0">
            <input type="hidden" name="nm" value="s_user_id">
            <input type="hidden" name="t_wd" value="">
            <a href="javascript:User_search();"><img src=../images/pop/button_search.gif border=0 align=absmiddle></a>
            <a href="javascript:CopyAuth()"><img src=../images/pop/button_ghbs.gif border=0 align=absmiddle></a>
        </td>
	</tr>
     	
  </table>     
 <input type="hidden" name="user_id" value="<%= user_id %>"> 
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

<script>
<%	if(cmd.equals("u")){%>
	alert("정상적으로 수정되었습니다.");
<%	}else{
		if(count==1){%>
	alert("정상적으로 등록되었습니다.");
<%		}
	}%>
</script>
</body>
</html>
