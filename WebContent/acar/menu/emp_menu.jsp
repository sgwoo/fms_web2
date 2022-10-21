<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="au_bean" class="acar.user_mng.AuthBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<style>

.modal_bg {position:fixed;top:0;left:0;z-index:100;width:93%;height:100%;background-color:rgba(0,0,0,.5); text-align: center; line-height: 1em; display: none;   border-radius: 13px; }
.modal_bg img { top: 50%; position: relative; display: inline-block; margin-top: 24px;  }

</style>

<div class="modal_bg" id="modal_bg" name="modal_bg" >
	<img src="/images/viewLoading.gif" />
</div>

<%	
	String acar_id = ck_acar_id;
	
	String auth_rw 	= request.getParameter("auth_rw")	== null ? "" : request.getParameter("auth_rw");
	String m_st 	= request.getParameter("m_st")		== null ? "" : request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")		== null ? "" : request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")		== null ? "" : request.getParameter("m_cd");
	String url 		= request.getParameter("url")		== null ? "" : request.getParameter("url");
	String m_id 	= request.getParameter("m_id")		== null ? "" : request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")		== null ? "" : request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")		== null ? "" : request.getParameter("c_id");
	String client_id= request.getParameter("client_id")	== null ? "" : request.getParameter("client_id");
	String accid_id = request.getParameter("accid_id")	== null ? "" : request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")	== null ? "" : request.getParameter("serv_id");
	String seq_no 	= request.getParameter("seq_no")	== null ? "" : request.getParameter("seq_no");
	
	String isQmenu	= request.getParameter("isQmenu")	== null ? "" : request.getParameter("isQmenu");
	
	String f_m_cd  = "";
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//마이메뉴
	MaMymenuDatabase mm_db = MaMymenuDatabase.getInstance();
	Vector menus2 = mm_db.getMyMenuList(acar_id);
	int menu_size2 = menus2.size();
		
	//소메뉴
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AuthBean au_r [] = umd.getAuthMaMeAll(acar_id, m_st, m_st2);
	
	//사용자정보	
	UsersBean user_bean = umd.getUsersBean(acar_id);
	
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
	

	function open_modal_bg(){
		
		var h = document.getElementById("left_menu_table").offsetHeight;
		document.getElementById("modal_bg").style.height = h + "px";
		document.getElementById("modal_bg").style.display = "block";
	}
	
	function top_modal_close(){
		
		if( parent.top_menu ){
			if(typeof parent.top_menu.close_modal_bg != "undefined"){
				parent.top_menu.close_modal_bg();
			}
		}
	}
	
	function close_modal_bg(){
		
		document.getElementById("modal_bg").style.display = "none";
	}	
	
	function page_link(m_st, m_st2, m_cd, url, auth_rw, isQmenu){
		
		parent.setLoadingLayer();
		
		var fm = document.form1;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value+"&isQmenu="+isQmenu;		
		var values2	= '&m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value+"&isQmenu="+isQmenu;				

		if(menu1 != menu2){		
			//parent.top_menu.location.href = 'emp_top.jsp'+values;
			
			parent.top_menu.showMenuDepth_2(m_st, m_st2);
			
			//location.href = 'emp_menu.jsp'+values;
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
			    if ( url.substr(0, 11) =='http://fms5'  ||  url.substr(0, 11) =='http://fms4' ) {	
			          var name5='<%=user_bean.getId()%>';
			          var pass5='<%=user_bean.getUser_psd()%>';			          			    
				window.open(url + "?name="+name5+"&passwd="+pass5 + "&s_width="+s_width+"&s_height="+s_height, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			   } else {	
				window.open(url, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
			  }
			}else{
				var pageUrl = '<%=au_bean.getUrl()%>';
				
				if( pageUrl != null && pageUrl.length > 0 ){
					parent.setLoadingLayer();
					parent.d_content.location ="<%=au_bean.getUrl()%>?m_st=<%=au_bean.getM_st()%>&m_st2=<%=au_bean.getM_st2()%>&m_cd=<%=au_bean.getM_cd()%>&auth_rw=<%=au_bean.getAuth_rw()%>"+values;
				}
			}
		}else
		<% } %>
		{}	
	}
	
	function nopage(){	
		parent.d_content.location = "about:blank";	
	}
	
	function fnMymenuLink(v){
		var isQmenu = '<%=isQmenu %>';
		
		var m_st = '<%=m_st %>';
		var m_st2 = '<%=m_st2 %>';
		var m_cd = '<%=m_cd %>';
		
		if( isQmenu == 'true' ){
			document.getElementById("depth_3_"+m_st+m_st2+m_cd).click();
			
			//locationUrl( parseInt(m_cd) - 1 );
		}
	}
//-->
</script>
</head>
<!-- onload 추가  -->
<body bgcolor="#FFFFFF" text="#000000" onload="fnMymenuLink('<%=m_cd %>'); top_modal_close();" >
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
        <table width="100%" border="0" cellspacing="0" cellpadding="0" id="left_menu_table" >
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
	                                        <font color=#ffffff>
		                                        <b>
		                                        	<%=nm_db.getMenuNm(m_st, "00", "00").toString().replaceAll("외부-", "")%>
		                                       	</b>
	                                       	</font>
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
        
        						f_m_cd = au_bean.getM_cd();
  						%>		
                        <tr>
                            <td align=center>
                                <table width=158 border=0 cellspacing=0 cellpadding=0>
                                    <tr>
                                        <td height=2 colspan=2></td>
                                    </tr>
                                    <tr onMouseOver="this.style.backgroundColor='#ECEBE6'"  onMouseOut="this.style.backgroundColor=''"> 
                                      <td width=19 align=right  valign=bottom>
                                      	<a href="javascript:locationUrl('<%=i%>')"><%=i+1%>.</a>
                                     	</td>
                                      	<td width=139 height=17 valign=bottom>&nbsp;
                                      		<a href="javascript:locationUrl('<%=i%>')" id="depth_3_<%=au_bean.getM_st() %><%=au_bean.getM_st2() %><%=au_bean.getM_cd() %>" ><%=au_bean.getM_nm()%></a>
										</td>
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
		  <!--마이메뉴 시작 : 변경방식-->
		  <%if(!nm_db.getWorkAuthUser("아마존카이외",acar_id) && !isExtStaff){%>
		    <tr>
		        <td align=right>
		            <table width=162 border=0 cellspacing=0 cellpadding=0 background=/acar/images/mymenu_bg.gif>
		                <tr>
		                    <td>
		                    	<a href="javascript:page_link('99','01','04','/acar/user_mng/my_menu.jsp',false)">
		                    		<img src=/acar/images/mymenu_1.gif border=0>
	                    		</a>
	                    	</td>
		                </tr>
		                <tr>
		                    <td height=3></td>
		                </tr>
                        <tr> 
                            <td align="center"> 
                                <table width="146" border="0" cellspacing="0" cellpadding="0">
                            <%	for (int i = 0 ; i < menu_size2 ; i++){
            						Hashtable menu2 = (Hashtable)menus2.elementAt(i);%>
                                    <tr onMouseOver="this.style.backgroundColor='#E4FBFF'"  onMouseOut="this.style.backgroundColor=''" > 
                                        <td width=10 align="right" >
                                        	<img src=/acar/images/mymenu_dot.gif align=absmiddle />
                                       	</td>
                                        <td width=136 height="16"  valign="bottom" style="font-size:8pt">&nbsp;
                                        	<a href="javascript:page_link('<%=menu2.get("M_ST")%>','<%=menu2.get("M_ST2")%>','<%=menu2.get("M_CD")%>','<%=menu2.get("URL")%>','<%=menu2.get("AUTH_RW")%>', true)">
                                        		<%=menu2.get("M_NM")%>
                                        	</a>
                                        </td>
                                    </tr>
                                    <%	}%>
                                    <%	if(menu_size2 == 0){%>
                                    <tr> 
                                      <td height="20" colspan=2>마이메뉴를 설정하십시오.</td>
                                    </tr>
                                    <%	}%>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td height=5></td>
                        </tr>
                        <tr>
		                    <td><img src=/acar/images/mymenu_2.gif></td>
		                </tr>
                    </table>
                </td>
            </tr>
          <%}%>
		  <!--마이메뉴 끝-->			  	  
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
		//page_link('<%=m_st%>','<%=m_st2%>','<%=m_cd%>','<%=url%>','<%=auth_rw%>');
	<%}%>	
//-->
</script>
</body>
</html>