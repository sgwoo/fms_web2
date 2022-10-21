<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="au_bean" class="acar.user_mng.AuthBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%	
	String acar_id = ck_acar_id;
	
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_st 	= request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"":request.getParameter("m_cd");
	String url 		= request.getParameter("url")==null?"":request.getParameter("url");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
	String f_m_cd  = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//마이메뉴
	MaMymenuDatabase mm_db = MaMymenuDatabase.getInstance();
	Vector menus2 = mm_db.getMyMenuList(acar_id);
	int menu_size2 = menus2.size();
	
	//소메뉴
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AuthBean au_r [] = umd.getAuthMaMeAll(acar_id, m_st, m_st2);
%>

<html>
<head>
<title>소메뉴목록</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/index.css">
<script language='javascript'>
<!--
	var s_width = screen.width;
	var s_height = screen.height;	
	
	function page_link(m_st, m_st2, m_cd, url, auth_rw){
		
		var fm = document.form1;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;		
		var values2	= '&m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;				
		
		if(menu1 != menu2){		
			parent.top_menu.location.href = 'subcont_top.jsp'+values;
			location.href = 'subcont_menu.jsp'+values;
		}	
		
		if(url != '' && url.substr(0,4)=='http'){
			window.open(url, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
		}else if(url != '' && url.substr(1,3)!='http'){
			if(url.lastIndexOf('?')!=-1){
				parent.d_content.location.href = url+''+values2;				
			}else{
				parent.d_content.location.href = url+''+values;
			}
		}else{	
			parent.d_content.location.href = '../include/no_page.html';
		}			
	} 
	
	function locationUrl(idx){	
	
		var fm = document.form1;	
		var values 	= '&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;			
		
<%		for(int i=0; i<au_r.length; i++){
    		au_bean = au_r[i];%>		
		if(idx=="<%=i%>"){
			var url = '<%=au_bean.getUrl()%>';
			if(url != '' && url.substr(0,4)=='http'){
				window.open(url, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			}else{
				parent.d_content.location ="<%=au_bean.getUrl()%>?m_st=<%=au_bean.getM_st()%>&m_st2=<%=au_bean.getM_st2()%>&m_cd=<%=au_bean.getM_cd()%>&auth_rw=<%=au_bean.getAuth_rw()%>"+values;
			}
		}else
		<% } %>
		{}	
	}
	
	function nopage(){	
		parent.d_content.location = "about:blank";	
	}	
//-->
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="165" border="0" cellspacing="0" cellpadding="0">
  <form name="form1" method="post" action="">
<input type='hidden' name="m_st" value="<%=m_st%>">
<input type='hidden' name="m_st2" value="<%=m_st2%>">
<input type='hidden' name="m_cd" value="<%=m_cd%>">
<input type='hidden' name="url" value="<%=url%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="user_id" value="<%=acar_id%>">
<input type='hidden' name='br_id' value="<%=acar_br%>">
<input type='hidden' name='m_id' value="<%=m_id%>">
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name="accid_id" value="<%=accid_id%>">
<input type='hidden' name="serv_id" value="<%=serv_id%>">
<input type='hidden' name="seq_no" value="<%=seq_no%>">
 	  
<tr> 
    <td valign="top"> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height=5></td>
            </tr>
            <tr> 
                <td valign="top" align=right> 
                    <table width=162 cellspacing=0 cellpadding=0 border=0 height=100% background=/acar/images/sub_m_bg.gif>
                        <tr>
                            <td>
                                <table width=162 cellspacing=0 cellpadding=0 border=0 background=/acar/images/sub_m_img1.gif>
                                    <tr>
                                        <td height=2></td>
                                    </tr>
                                    <tr>
                                        <td height=31  align=center style="font-size:12pt">
                                            <font color=#ffffff><b>
                                                <%if(ck_acar_id.equals("000174")){%>현대자동차<%}else if(ck_acar_id.equals("000189")||ck_acar_id.equals("000190")||ck_acar_id.equals("000191")||ck_acar_id.equals("000294")){%>기아자동차<%}else{%><%=nm_db.getMenuNm(m_st, "00", "00")%><%}%>
                                            </b></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table width=162 cellspacing=0 cellpadding=0 border=0  background=/acar/images/sub_m_img3.gif>
                                    <tr>
                                        <td height=2></td>
                                    </tr>
                                    <tr>
                                        <td height=32 align="center"><font color=4ca8c2><b><%=nm_db.getMenuNm(m_st, m_st2, "00")%></b></font></td>
                                    </tr>
                                </table>
                            </td>                           
                        </tr>
                        <tr>
                            <td height=5></td>
                        </tr>
        				<!--소메뉴 시작 : 기존방식-->
        				<%	for(int i=0; i<au_r.length; i++){
        				    	au_bean = au_r[i];
        						f_m_cd = au_bean.getM_cd();%>		
                        <tr>
                            <td align=center>
                                <table width=158 border=0 cellspacing=0 cellpadding=0>
                                    <tr>
                                        <td height=2 colspan=2></td>
                                    </tr>
                                    <tr onMouseOver=this.style.backgroundColor='#ECEBE6'  onMouseOut=this.style.backgroundColor=''> 
                                      <td width=19 align=right  valign=bottom><a href="javascript:locationUrl('<%=i%>')"><%=i+1%>.</a></td>
                                      <td width=139 height=17 valign=bottom>&nbsp;<a href="javascript:locationUrl('<%=i%>')"><%=au_bean.getM_nm()%></a></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr> 
                          <td height=1 align=center><img src=/acar/images/sub_m_line.gif height=1></td>
                        </tr>
                        <%	}%>
                        <tr>
                            <td height=10></td>
                        </tr>
                        <tr> 
                          <td><img src=/acar/images/sub_m_img4.gif></td>
                        </tr>
                    </table>
                </td>
            </tr> 
            <tr>
                <td height=5></td>
            </tr>         		  	  
            </table>
        </td>
    </tr>
  </form>
</table>
<script language='javascript'>
<!--
	<%if(m_cd.equals("") && au_r.length>0){%>
		nopage();
	<%}%>
	<%if(!m_cd.equals("") && au_r.length>0 && AddUtil.parseInt(auth_rw) > 0){%>
		page_link('<%=m_st%>','<%=m_st2%>','<%=m_cd%>','<%=url%>','<%=auth_rw%>');
	<%}%>	
//-->
</script>
</body>
</html>