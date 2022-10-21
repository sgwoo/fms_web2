<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그아웃 처리를 위한------------------
	String login_time = Util.getLoginTime();		//로그인시간
	String ip = request.getRemoteAddr(); 				//로그인IP
	
	//메뉴
	Vector menu_vt = nm_db.getXmlMenuList(ck_acar_id);
	int menu_size = menu_vt.size();
	
		
	for(int i=0; i<menu_size; i++){
		
	
	}
	
	//바로가기메뉴리스트
	Vector qmenus = nm_db.getXmlQLinkList(ck_acar_id);
	int qmenu_size = qmenus.size();
%>

<html>
<head>
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/sub.css">

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>


	
<script language='javascript'>
<!--
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		i_no.location ='/acar/del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}			

	//사용자정보 팝업
	function UserUpdate(){				
		var SUBWIN="/fms2/menu/info_u.jsp?user_id=<%=ck_acar_id%>";
		window.open(SUBWIN, "InfoUp", "left=10, top=10, width=800, height=850, scrollbars=yes");
	}		
	
	//메모 보기
	function Memo(){
		var SUBWIN="/acar/memo/memo_frame.jsp?user_id=<%=ck_acar_id%>";	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=650, height=650, scrollbars=yes");
	}	
	//메일 팝업
	function mail_open(){
		var s_width = screen.width;
		var s_height = screen.height;
		var SUBWIN="http://mail.amazoncar.co.kr/";
		newwin=window.open("","MAIL","scrollbars=yes, status=yes, resizable=1");
		if (document.all){
			newwin.moveTo(0,0);
			newwin.resizeTo(screen.width,screen.height-50);
		}	
		newwin.location=SUBWIN;
	}			

	//연락망
	function tel(){
		var SUBWIN="/acar/user_mng/sostel_frame.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=800, height=800, scrollbars=yes");
	}	
	
	//메뉴명 검색
	function menu_search(){
		
	}
	
	//퀵링크
	function page_link(){
		var fm = document.form1;
		var qlink = fm.qlink.options[fm.qlink.selectedIndex].value;		

		if(qlink == ''){ return;}		
		var qlinks = qlink.split(" ");		
		var url     = "";
		var m_st 	  = qlinks[0];
		var m_st2 	= qlinks[1];
		var m_cd 	  = qlinks[2];
		var auth_rw	= qlinks[3];
		var url_l 	= qlinks[4];
		var url_s		= qlinks[5];	
		var folder 	= m_st+''+m_st2+''+m_cd;	

		if(fm.l_cd.value == '')		url = url_l;			
		else											url = url_s;
			
		var values 	= '?menu_st=quick&m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id=<%=acar_br%>&user_id=<%=ck_acar_id%>&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;			
		
		if(folder == '030102' && fm.l_cd.value != '') values += '&s_st=3&s_kd=1&t_wd='+fm.l_cd.value; //자동차사고   040102
		if(folder == '040301' && fm.l_cd.value != '') values += '&f_list=pay';												//할부금     050301 
		if(folder == '040404' && fm.l_cd.value != '') values += '&f_list=scd';												//할부금스케줄  050502
		if(folder == '040512' && fm.l_cd.value != '') values += '&s_kd=2&t_wd1='+fm.l_cd.value;				//세금계산서   050701 
				
		
		parent.d_content.location = url+''+values;	
		
		fm.qlink.value = '';
				
	}
	
	//메뉴보기
	function showMenuDepth(m_st){
		var menu = $('#sub-menu01');
		menu.css("display","block");
		parent.frames["d_content"].document.body.appendChild(document.getElementById("sub-menu01"));
	}
	
//-->
</script>



	
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form name="form1" method="post" action="">
<input type='hidden' name="url" value="">
<input type='hidden' name="auth_rw" value="">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value="">
<input type='hidden' name="c_id" value="">
<input type='hidden' name='client_id' value="">
<input type='hidden' name="accid_id" value="">
<input type='hidden' name="serv_id" value="">
<input type='hidden' name="seq_no" value="">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center background=/acar/images/top_bg.gif><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src=/acar/images/logo.gif width=90 height=23></a></td>
        <td valign=top background=/acar/images/top_bg.gif>
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td align='right'>
                                <!--메인  화면-->
                                <a href="/fms2/menu/amazoncar_main.jsp" target=d_content title="메인화면"><img src=/acar/images/top_b_home.gif width=48 height=14 border=0></a>
                                &nbsp;&nbsp;<img src=/acar/images/top_b_vline.gif width=1 height=14>&nbsp;&nbsp;
	                              <!-- 나의 메뉴 -->
	                              <a href="#" title=사이트맵>나의 메뉴</a>
	                              &nbsp;&nbsp;<img src=/acar/images/top_b_vline.gif width=1 height=14>&nbsp;&nbsp;
	                              <!-- 사이트링크 -->
	                              <a href="#" target=d_content title=사이트맵>사이트링크</a>
	                              &nbsp;&nbsp;<img src=/acar/images/top_b_vline.gif width=1 height=14>&nbsp;&nbsp;
                    </td>  
                    <td width=197>
                        <table width=197 border=0 cellpadding=0 cellspacing=0 background=/acar/images/quick_bg.gif>
                            <tr>                                
                                <td width=10 height=30><img src=/acar/images/quick_1.gif width=10 height=30></td>
                                <td height=30>
                                    <input type="text" name="s_menu" id="s_menu" class="text" value="" placeholder="메뉴명 검색" />
                                </td>
                                <td width=60>&nbsp;<a href="javascript:menu_search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a></td>
                                <td width=10 height=30><img src=/acar/images/quick_1.gif width=10 height=30></td>
                            </tr>
                        </table>
                    </td>                                        
                    <td width=197>
                        <table width=197 border=0 cellpadding=0 cellspacing=0 background=/acar/images/quick_bg.gif>
                            <tr>
                                <td width=4 height=30><img src=/acar/images/quick_1.gif width=4 height=30></td>
                                <td width=64 align=center><img src=/acar/images/quick_2.gif width=58 height=10></td>
                                <td>
                                    <select name="qlink" onChange="javascript:page_link()" style='height:19px'>
                                        <option value="">바로가기--------</option>
                        				        <option value=""></option>
                        				        <%	//바로가기 리스트 조회
                        									for (int i = 0 ; i < qmenu_size ; i++){
                        										Hashtable qmenu = (Hashtable)qmenus.elementAt(i);%>
                                        		<option value="<%=qmenu.get("URL")%>"><%=qmenu.get("M_NM")%></option>					
                        								<%	}%>
                                    </select>
                                </td>
                                <td width=4><img src=/acar/images/quick_3.gif width=4 height=30></td>
                            </tr>
                        </table>
                    </td>                    
                    <td width=100>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td valign=top>
            <table width=169 border=0 cellpadding=0 cellspacing=0 background=/acar/images/p_img.gif>
                <tr>
                    <td height=28 align=center>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td width=95>
                                    <table width=95 border=0 cellspacing=0 cellpadding=0>
                                        <tr>
                                            <td height=5></td>
                                        </tr>
                                        <tr>
                                            <td>&nbsp;<strong><%=session_user_nm%></strong></td>                                        		                
        		                        </tr>
        		                    </table>
        		                </td>
                            <!--Logout  -->
                            <td width=49><a href="javascript:Logout();"><img src=/acar/images/button_logout.gif width=49 height=14 border=0></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=4 rowspan=2><img src=/acar/images/menu_left.gif width=4 height=75></td>
                </tr>
                <tr>
                    <td height=47 align=center valign=top>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                        	<%                        		
                        		String memoImg = "<img src=/acar/images/button_memo.gif width=17 height=10 border=0>";
                        		String memoEtc = " width=17 ";
                        		String telFn = "tel(); ";                        		                        		
                        		String btnUserInfo = "<td width=38 height=23 align=right><a href=javascript:UserUpdate() title=개인정보수정><img src=/acar/images/button_m.gif width=34 height=10 border=0></a></td>";
                        		String btnMemo = "<td "+memoEtc+"><a href=javascript:Memo(); title=''>"+memoImg+"</a></td>";
                        		String btnMail = "<td width=17><a href=javascript:mail_open(); title='메일확인'><img src=/acar/images/button_mail.gif width=17 height=10 border=0></a></td>";
                        		String btnTel = "<td><a href=javascript:"+telFn+"><img src=/acar/images/button_tel.gif border=0></a></td>";
                        		String line = "<td width=9 align=center><img src=/acar/images/pro_vline.gif width=1 height=10></td>";
                        	%>
                            <tr>
										          <!--개인  정보-->
										          <%=btnUserInfo %>
										          <%=line %>										
										          <!-- 메모확인 -->
										          <%=btnMemo %>
										          <%=line %>										
										          <!--메일  확인-->
										          <%=btnMail %>
										          <%=line %>										
										          <!-- 연락망 -->
										          <%=btnTel %>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td valign=top>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td height=6></td>
                </tr>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" background="/acar/images/menu_bg.gif">
                            <tr>
                              <td width="20" height=31>&nbsp;</td>
                              <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('01');"><font color=white><b>영업관리</b></font></td>                    		      
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('02');"><font color=white><b>차량관리</b></font></a></td>
                    		      <td align='center' valign='middle' width=120><a href="javascript:showMenuDepth('03');"><font color=white><b>사고 및 보험</b></font></a></td>
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('04');"><font color=white><b>재무회계</b></font></a></td>
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('05');"><font color=white><b>채권관리</b></font></a></td>
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('06');"><font color=white><b>매각관리</b></font></a></td>
                    		      <td align='center' valign='middle' width=120><a href="javascript:showMenuDepth('07');"><font color=white><b>협력업체관리</b></font></a></td>
                    		      <td align='center' valign='middle' width=120><a href="javascript:showMenuDepth('08');"><font color=white><b>현황 및 통계</b></font></a></td>
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('09');"><font color=white><b>경영정보</b></font></a></td>
                    		      <td align='center' valign='middle' width=100><a href="javascript:showMenuDepth('10');"><font color=white><b>인사관리</b></font></a></td>
                    		      <td align='center' valign='middle' width=120><a href="javascript:showMenuDepth('11');"><font color=white><b>FMS운영관리</b></font></a></td>
                    		      <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td height=10></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
	<div id="sub-menu01" style="display:none" class="menu">
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>
		<a href="">영업관리</a><br/>

	</div>
	<div id="sue-menu02" style="display:none" class="menu">
		<a href="">차량관리</a><br/>
		<a href="">차량관리</a><br/>
		<a href="">차량관리</a><br/>
		<a href="">차량관리</a><br/>
	</div>
<script>

</script>

</body>
</html>