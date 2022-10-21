<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,java.io.*" %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�α׾ƿ� ó���� ����------------------
	String login_time = Util.getLoginTime();		//�α��νð�
	String ip = request.getRemoteAddr(); 				//�α���IP
	//���������
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(ck_acar_id);
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	//�ٷΰ���޴�����Ʈ
	Vector qmenus = nm_db.getXmlQLinkList(ck_acar_id);
	int qmenu_size = qmenus.size();
	
	InputStream is = this.getClass().getResourceAsStream("/acar/database/db.properties");
	Properties dbProps = new Properties();
    try {
        dbProps.load(is);
    }
    catch (Exception e) {
        System.err.println("Can't read the properties file. " +
            "Make sure db.properties is in the CLASSPATH");
        return;
    }
	String dbUrl = dbProps.getProperty("acar.url", "");
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<style>
@font-face {
    font-family: 'icomoon';
    src:    url('/fms2/lib/fonts/icomoon.eot?rtmp4o');
    src:    url('/fms2/lib/fonts/icomoon.eot?rtmp4o#iefix') format('embedded-opentype'),
        url('/fms2/lib/fonts/icomoon.ttf?rtmp4o') format('truetype'),
        url('/fms2/lib/fonts/icomoon.woff?rtmp4o') format('woff'),
        url('/fms2/lib/fonts/icomoon.svg?rtmp4o#icomoon') format('svg');
    font-weight: normal;
    font-style: normal;
}
@font-face {
  font-family: 'Nanum Square';
  font-style: normal;
  font-weight: 400;
  src: url(/fms2/menu/font/NanumSquareR.eot);
  src: local('Nanum Square Regular'),
       local('NanumSquareR'),
       url(/fms2/menu/font/NanumSquareR.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareR.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareR.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareR.ttf) format('truetype');
}

@font-face {
  font-family: 'Nanum Square';
  font-style: bold;
  font-weight: 700;
  src: url(/fms2/menu/font/NanumSquareB.eot);
  src: local('Nanum Square Bold'),
       local('NanumSquareB'),
       url(/fms2/menu/font/NanumSquareB.eot?#iefix) format('embedded-opentype'),
       url(/fms2/menu/font/NanumSquareB.woff2) format('woff2'),
       url(/fms2/menu/font/NanumSquareB.woff) format('woff'),
       url(/fms2/menu/font/NanumSquareB.ttf) format('truetype');
}
[class^="icon-"], [class*=" icon-"] {
    /* use !important to prevent issues with browser extensions that change fonts */
    font-family: 'icomoon' !important;
    speak: none;
    font-style: normal;
    font-weight: normal;
    font-variant: normal;
    text-transform: none;
    line-height: 1;

    /* Better Font Rendering =========== */
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}
.icon-user:before {
    content: "\e971";
}
.open{
	background-color:#f6f6f6;
}

.open b{
	color:#349BD5 !important;
}
.topmenu b{
	color:#fff;
	font-family:'Nanum Square';
	font-size:14px;
}
.qlink{
	width:120px;
	border:1px solid #349BD4;
	background-position:100px;
	background-color:#fff;
	background-image:url('/fms2/menu/images/qlink_arrow.png');
  	-webkit-appearance: none; 
  	-moz-appearance: none;
	appearance: none;
	background-repeat:no-repeat;
}
select::-ms-expand {
    display: none;
}
.menu_search{
	background-color:#fff !important;
	width:100px;
	border:1px solid #349BD4 !important;
}
.console_margin {
	-webkit-margin-before: -3px;
	margin-top: -5px;
}
</style>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<script language='javascript'>
Kakao.init("4419b2a3a6bac750d7b19ffd37d7b995");
	 var m_st_t = null;
<!--
	//�α׾ƿ�
	function Logout() {
		if (!confirm("�α׾ƿ� �Ͻðڽ��ϱ�?")) {
			return;
		} else {
			if (Kakao.Auth.getAccessToken()) {
				Kakao.Auth.logout(function() {
					//console.log(Kakao.Auth.getAccessToken());
					parent.location.href ='/acar/menu/del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
				});
			} else {				
				parent.location.href ='/acar/menu/del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
			}
		}
	}

	//��������� �˾�
	function UserUpdate(){				
		var SUBWIN="/fms2/menu/info_u.jsp?user_id=<%=ck_acar_id%>";
		window.open(SUBWIN, "InfoUp", "left=10, top=10, width=900, height=800, scrollbars=yes");
	}		
	
	//�޸� ����
	function Memo(){
		var SUBWIN="/acar/memo/memo_frame.jsp?user_id=<%=ck_acar_id%>";	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=650, height=650, scrollbars=yes");
	}	
	
	//�޸� ����
	function send_sms(){
		var SUBWIN="/acar/sms_gate/sms_gate.jsp?user_id=<%=ck_acar_id%>";	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=850, height=850, scrollbars=yes");
	}

	// īī�� �˸���
	function send_kakao_alimtalk(){
		var SUBWIN="/acar/kakao/alim_talk_new.jsp?user_id=<%=ck_acar_id%>";
		//window.open(SUBWIN, "MemoUp", "left=10, top=10, width=1200, height=900, scrollbars=yes");
		window.open(SUBWIN);
	}     

	// īī�� �˸���
	function send_e_doc(){
		var SUBWIN="/acar/e_doc/e_doc_mng.jsp?user_id=<%=ck_acar_id%>";
		//window.open(SUBWIN, "MemoUp", "left=10, top=10, width=1200, height=900, scrollbars=yes");
		window.open(SUBWIN);
	}     
	
	//���� �˾�
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

	//������
	function tel(){
		var SUBWIN="/acar/user_mng/sostel_frame.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=800, height=800, scrollbars=yes");
	}	
	
	//����Ʈ��ũ
	function site_link(){
		var SUBWIN="/fms2/menu/site_link.jsp";	
		window.open(SUBWIN, "SiteUp", "left=10, top=10, width=1024, height=650, scrollbars=yes");
	}
	
	//Ȩ����
	function Home(){
		if(m_st_t==null){}else{
	$('.topmenu').removeClass("open");
	$('.menu',parent.frames['sub_menu'].document).css("display","none");
	var menuDiv = $("#"+m_st_t,parent.frames['sub_menu'].document);
	
		
	if(menuDiv.hasClass("open")){
		parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,0,*'
		menuDiv.removeClass("open");
	}
		var fm = document.form1;
		fm.target= 'd_content';
		fm.action = '/fms2/menu/emp_content.jsp';
		fm.submit();
	}	
}
	//�޴��� �˻�
	function menu_search(){
		var SUBWIN="/fms2/menu/search_menu.jsp?t_wd="+document.form1.s_menu.value;	
		window.open(SUBWIN, "SearchMenu", "left=10, top=10, width=650, height=650, scrollbars=yes");
		
		document.form1.s_menu.value = '';
		document.form1.s_menu.placeholder = "�޴��� �˻�";
	}
	
	
	//����ũ
	function page_link(){
		var fm = document.form1;
		var qlink = fm.qlink.options[fm.qlink.selectedIndex].value;		
		var qlinkMenuFullPath = fm.qlink.options[fm.qlink.selectedIndex].getAttribute("param");
		
		var menuCookie = qlinkMenuFullPath.split(":")[0] + " > " + qlinkMenuFullPath.split(":")[1] + " > " + qlinkMenuFullPath.split(":")[2];
		$.cookie("currentMenuNavi",menuCookie,{expires: 1, path: '/', domain:'.amazoncar.co.kr'});
		
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
		
		if(folder == '030102' && fm.l_cd.value != '') values += '&s_st=3&s_kd=1&t_wd='+fm.l_cd.value; //�ڵ������   040102
		if(folder == '040301' && fm.l_cd.value != '') values += '&f_list=pay';												//�Һα�     050301 
		if(folder == '040404' && fm.l_cd.value != '') values += '&f_list=scd';												//�Һαݽ�����  050502
		if(folder == '040512' && fm.l_cd.value != '') values += '&s_kd=2&t_wd1='+fm.l_cd.value;				//���ݰ�꼭   050701 
				
		
		parent.d_content.location = url+''+values;	
		
		fm.qlink.value = '';
				
	}
	
	//�޴�����
	function showMenuDepth(m_st){
		m_st_t = m_st;
		$('.topmenu').removeClass("open");
		
		
		$('.menu',parent.frames['sub_menu'].document).css("display","none");
		var menuDiv = $("#"+m_st,parent.frames['sub_menu'].document);
		var menuHeight = menuDiv.css("height")+20;

//		alert(menuHeight);
		parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,'+menuHeight+',*'
		
		if(menuDiv.hasClass("open")){
			parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,0,*'
			menuDiv.removeClass("open");
		}else{
			$('.menu',parent.frames['sub_menu'].document).removeClass("open");
			menuDiv.slideDown();
			menuDiv.addClass("open");
			
			var id = "#" + m_st;
			$(id).addClass("open");
			
		}
	}
	function MymenuFix(){
		if($('#myMenuOn').text()==' ON'){
			parent.document.getElementsByTagName( 'frameset' )[ 1 ].cols = '180,*';
			parent.document.getElementsByTagName( 'frameset' )[ 0 ].rows = '90,0,*';
			$('#myMenuOn').text(" OFF");
		}else{
			parent.document.getElementsByTagName( 'frameset' )[ 1 ].cols = '0,*';
			$('#myMenuOn').text(" ON");
		}

	}
function EnterDown() {
		var x = document.getElementById("s_menu");
		var keyValue = event.keyCode;
	
		if (document.hasFocus()) {
   			 
					if (keyValue =='13') menu_search();
		} 	else {
 
		}
 }	
 

 
//-->
</script>
<script type="text/javascript">
$(window).resize(function (){
	  // width���� ��������
	  var width_size = window.outerWidth;
	  
	  // 1200 �������� if������ Ȯ��
	  if (width_size < 1290) {
		  $("#first_width").css("width", "1%");
		  $("#last_width").css("width", "1%");
	  } else if (width_size > 1290) {
		  $("#first_width").css("width", "5%");
		  $("#last_width").css("width", "5%");
	  }
})
</script>



	
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ondragstart="return false" style="min-width:1245px; ">

<form name="form1" method="post" action="">
<input type='hidden' name="url" value="">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value="">
<input type='hidden' name="user_id" value="<%=ck_acar_id%>">
<input type='hidden' name='br_id' value="<%=user_bean.getBr_id()%>">
<input type='hidden' name="c_id" value="">
<input type='hidden' name='client_id' value="">
<input type='hidden' name="accid_id" value="">
<input type='hidden' name="serv_id" value="">
<input type='hidden' name="seq_no" value="">
<input type="hidden" name="temp" value="">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center><a href="http://www.amazoncar.co.kr" target=_blank title='�Ƹ���ī Ȩ������'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></a></td>
        <td valign=middle >
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>

                    <td align='right'>
                            <%
								if (dbUrl.contains("110")) {
							%>
								<span>#���߼���</span>
							<%
								}
							%>
                    			&nbsp;&nbsp;
                        		<!--�������� -->
                        		<span class="icon-user" style="margin-right:-10px;"></span>
                                &nbsp;&nbsp;<a href=javascript:UserUpdate() title="������������"><strong><%=session_user_nm%></strong></a>
                                <!--Logout  -->
        		                &nbsp;&nbsp;<a href="javascript:Logout();" title="Logout" style="background-color: #fae100; font-weight: bold; padding: 5px;">�α׾ƿ�</a>
                   				&nbsp;|&nbsp;
                                <!--����  ȭ��
                                <a href="/fms2/menu/emp_content.jsp" target=d_content title="����ȭ��">HOME</a>-->
                                <a href="javascript:Home();" title="HOME">HOME</a>
                                &nbsp;|&nbsp;
	                              <!-- ���� �޴� -->
	                              <a href="javascript:showMenuDepth('12');" title="���� �޴�">���� �޴�</a> 
	                              <a href="javascript:MymenuFix('13');"><span style="font-size:9px;font-weight:bold;" id="myMenuOn"> ON</span></a>
	                              &nbsp;|&nbsp;
        		                    <!-- �޸�Ȯ�� -->										          
										            <a href=javascript:Memo(); title='�޸𺸱�'>�޸�</a>
										            &nbsp;|&nbsp;
										            <!--����  Ȯ��-->
										            <a href=javascript:mail_open(); title='����Ȯ��'>����</a>
										            &nbsp;|&nbsp;
										            <!-- ������ -->
										            <a href=javascript:tel(); title='������'>������</a>
										            &nbsp;|&nbsp;
	                              <!-- ����Ʈ��ũ -->
	                              <a href="javascript:site_link();" title='����Ʈ��ũ'>����Ʈ��ũ</a>
	                              &nbsp;|&nbsp;
	                              <!-- SMS -->
	                              <a href="javascript:send_sms();" title='SMS������'>SMS</a>
                          
	                              &nbsp;|&nbsp;
	                              <!-- KAKAO �˸��� -->
                                  <a href="#" onclick="send_kakao_alimtalk()">�˸���</a>
                                      
                                  &nbsp;|&nbsp;
                                  <a href="https://center-pf.kakao.com/" target="_blank">
                                  		<img src=/fms2/menu/images/kakao.png align=absmiddle class="console_margin">
                                  </a>
<%--                                   <%if(nm_db.getWorkAuthUser("������",ck_acar_id)){%>                           --%>
                                  &nbsp;|&nbsp;
                                   <a href="javascript:send_e_doc();" title="e_doc" style="background-color: #f1f5f4; font-weight: bold; padding: 5px;">���ڹ���</a>
                                   <!-- <a href="#" onclick="send_e_doc()"><span style="font-size: 13px; font-weight:bold;"> </a>--> 
<%--                                   <%} %>  --%>

                    </td>  
                                           
                    <td width=197>
                        <table width=197 border=0 cellpadding=0 cellspacing=0>
                            <tr>
                                <td align="right" style="padding-right:10px;">
                                    <select name="qlink" class="qlink" onChange="javascript:page_link()" style='height:19px'>
                                        <option value="">����ũ</option>
                        				        <option value=""></option>
                        				        <%	//�ٷΰ��� ����Ʈ ��ȸ
                        									for (int i = 0 ; i < qmenu_size ; i++){
                        										Hashtable qmenu = (Hashtable)qmenus.elementAt(i);%>
                                        		<option value="<%=qmenu.get("URL")%>" param="<%=qmenu.get("M_NM1")%>:<%=qmenu.get("M_NM2")%>:<%=qmenu.get("M_NM3")%>"><%=qmenu.get("M_NM")%></option>					
                        								<%	}%>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </td>  
                    <td width=170>
                        <table width=170 border=0 cellpadding=0 cellspacing=0>
                            <tr>                                
                                <td width="100px">
                                    <input type="text" name="s_menu" id="s_menu" class="text menu_search" value="" placeholder="�޴��� �˻�" style="height:19px;" onKeydown="javasript:EnterDown()" />
                                </td>
                                <td>
                                	<a href="javascript:menu_search();"><img src=/fms2/menu/images/search_img.png align=absmiddle></a>
                                </td>
                            </tr>
                        </table>
                    </td> 
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan='2' valign=top>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:#349BD5;">
                            <tr>
                                  <!-- <td width="85" height=40>&nbsp;</td> -->
                                  <td id="first_width" width="5%" height=40>&nbsp;</td>
                              	  <td align='center' valign='middle' width=100 id="01" class="topmenu"><a href="javascript:showMenuDepth('01');" title='��������'><b>��������</b></font></a></td>                    		      
                    		      <td align='center' valign='middle' width=100 id="02" class="topmenu"><a href="javascript:showMenuDepth('02');" title='��������'><b>��������</b></font></a></td>
                    		      <td align='center' valign='middle' width=120 id="03" class="topmenu"><a href="javascript:showMenuDepth('03');" title='��� �� ����'><b>��� �� ����</b></font></a></td>
                    		      <td align='center' valign='middle' width=100 id="04" class="topmenu"><a href="javascript:showMenuDepth('04');" title='�繫ȸ��'><b>�繫ȸ��</b></font></a></td>
                    		      <td align='center' valign='middle' width=100 id="05" class="topmenu"><a href="javascript:showMenuDepth('05');" title='ä�ǰ���'><b>ä�ǰ���</b></font></a></td>
                    		      <td align='center' valign='middle' width=100 id="06" class="topmenu"><a href="javascript:showMenuDepth('06');" title='�Ű�����'><b>�Ű�����</b></font></a></td>
                    		      <td align='center' valign='middle' width=120 id="07" class="topmenu"><a href="javascript:showMenuDepth('07');" title='���¾�ü����'><b>���¾�ü����</b></font></a></td>
                    		      <td align='center' valign='middle' width=120 id="08" class="topmenu"><a href="javascript:showMenuDepth('08');" title='��Ȳ �� ���'><b>��Ȳ �� ���</b></font></a></td>
                    		      <td align='center' valign='middle' width=100 id="09" class="topmenu"><a href="javascript:showMenuDepth('09');" title='�濵����'><b>�濵����</b></font></a></td>
                    		      <%if(!ck_acar_id.equals("000203") && !ck_acar_id.equals("000239")){%>
                    		      <td align='center' valign='middle' width=100 id="10" class="topmenu"><a href="javascript:showMenuDepth('10');" title='�λ����'><b>�λ����</b></font></a></td>
                    		      <%}%>
                    		      <td align='center' valign='middle' width=120 id="11" class="topmenu"><a href="javascript:showMenuDepth('11');" title='FMS�����'><b>FMS�����</b></font></a></td>
                    		      <!-- <td>&nbsp;</td> -->
                    		      <td id="last_width" width="5%">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

<script>
	
</script>

</body>
</html>
