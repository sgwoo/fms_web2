<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.memo.*,  acar.off_anc.*" %>
<%@ include file="/off/cookies.jsp" %>
<%
	String acar_id = ck_acar_id;
	
	//�α׾ƿ� ó���� ����------------------
	String login_time 	= Util.getLoginTime();		//�α��νð�
	String ip 		= request.getRemoteAddr(); 	//�α���IP
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	
	String m_st = "23";
	
	if(nm_db.getWorkAuthUser("�ܺ�_�ڵ�����",ck_acar_id)){
		m_st 	= "23";
	}else if(nm_db.getWorkAuthUser("�ܺ�_�����ü",ck_acar_id)){
		m_st 	= "24";
	}else if(nm_db.getWorkAuthUser("�ܺ�_���·�",ck_acar_id)){
		m_st 	= "25";
	}else if(nm_db.getWorkAuthUser("�ܺ�_���Ź��",ck_acar_id)){
		m_st 	= "26";
	}else if(nm_db.getWorkAuthUser("�ܺ�_��ǰ��ü",ck_acar_id)){
		m_st 	= "27";
	}else if(nm_db.getWorkAuthUser("�ܺ�_�ݼ�Ÿ",ck_acar_id)){
		m_st 	= "28";
	}else if(nm_db.getWorkAuthUser("�ܺ�_�ڵ������",ck_acar_id)){
		m_st 	= "29";
	}else if(nm_db.getWorkAuthUser("�ܺ�_�ڵ����˻�",ck_acar_id)){
		m_st 	= "31";
	}else if(nm_db.getWorkAuthUser("�ܺ�_����⵿",ck_acar_id)){
		m_st 	= "32";
	}else if(nm_db.getWorkAuthUser("�ܺ�_Ź�۾�ü",ck_acar_id)){
		m_st 	= "33";
	}
			
	UserMngDatabase umd = UserMngDatabase.getInstance();	
		
	//���������	
	UsersBean user_bean = umd.getUsersBean(acar_id);
		
	//��޴�
	Vector bu_menu = umd.getAuthMaMeAllOffBMenu(acar_id);
	int bumenu_size = bu_menu.size();

	//�߸޴� 
	Vector	 au_menu = umd.getAuthMaMeAll2(acar_id, m_st);
	int aumenu_size = au_menu.size();
	
	//��ü �������� ��ȸ
	String gubun 	= request.getParameter("gubun")==null?"c_year":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	OffAncDatabase oad = OffAncDatabase.getInstance();
	//��ü �������� ��ȸ
	AncBean a_r [] = oad.getAncAllOff(ck_acar_id);	
	
	
%>

<html>
<head>
<!-- <META HTTP-EQUIV="refresh" CONTENT="3600"> -->
<title>���¾�ü FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/off/include/sub.css">

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
</style>

<script language='javascript'>
<!--
	//�α׾ƿ�
	function Logout(){
		if(!confirm("�α׾ƿ� �Ͻðڽ��ϱ�?")){ return; }
		parent.location.href ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}	

	//��������� �˾�
	function UserUpdate(arg){
		var SUBWIN="./info_u.jsp?user_id="+arg;
		window.open(SUBWIN, "InfoUp", "left=100, top=10, width=500, height=350, scrollbars=yes");
	}
	
	//������
	function tel2(){
		var SUBWIN="./sawon2.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=700, height=700, scrollbars=yes");
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
			fm.action = '/off/menu/emp_content.jsp';
			fm.submit();
		}	
	}
	
	//�޴�����
	function showMenuDepth(m_st){
		m_st_t = m_st;
		$('.topmenu').removeClass("open");
		
		
		$('.menu',parent.frames['sub_menu'].document).css("display","none");
		var menuDiv = $("#"+m_st,parent.frames['sub_menu'].document);
		var menuHeight = menuDiv.css("height")+20;

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
	
//-->
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" ondragstart="return false" style="min-width:1245px; ">
<form name="form1" method="post" action="">
<input type='hidden' name="url" value="">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value="">
<input type='hidden' name="user_id" value="<%=acar_id%>">
<input type='hidden' name='br_id' value="<%=user_bean.getBr_id()%>">
<input type='hidden' name="c_id" value="">
<input type='hidden' name='client_id' value="">
<input type='hidden' name="accid_id" value="">
<input type='hidden' name="serv_id" value="">
<input type='hidden' name="seq_no" value="">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center><a href="http://www.amazoncar.co.kr" target=_blank title='�Ƹ���ī Ȩ������'><img src="/acar/images/logo_1.png" style="margin-left: 30px;"></a></td>
        <td style="margin:auto;text-align:right;" >
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td align='right'>
                        		<!--�������� -->
                        		<span class="icon-user" style="margin-right:-10px;"></span>
                                &nbsp;&nbsp;<a href="javascript:UserUpdate('<%=acar_id%>')" title="������������"><strong><%=session_user_nm%></strong></a>
                                <!--Logout  -->
        		                &nbsp;&nbsp;<a href="javascript:Logout();" title="Logout">�α׾ƿ�</a>
                   				&nbsp;|&nbsp;
                                <!--����  ȭ��-->
                                <a href="javascript:Home();" title="HOME">HOME</a>
                                &nbsp;|&nbsp;
								<!-- ������ -->
								<a href=javascript:tel2(); title='������'>������</a>
								
                    </td>
                    <td width="100">&nbsp;</td>
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
                        		<td width="85" height=40>&nbsp;</td>
                        <%
                        for (int i = 0 ; i < bumenu_size ; i++){
                    		Hashtable aumenu = (Hashtable)bu_menu.elementAt(i);
                    		String str = aumenu.get("M_NM").toString();
                        %>	
								<%if(str.equals("�������")){%>
								<td align='center' valign='middle' width=100 id="23" class="topmenu"><a href="javascript:showMenuDepth('23');" title='�������'><b>�������</b></a></td>
								<%}else if(str.equals("�������")){%>
								<td align='center' valign='middle' width=100 id="24" class="topmenu"><a href="javascript:showMenuDepth('24');" title='�������'><b>�������</b></a></td>
								<%}else if(str.equals("�ڵ�������")){%>
								<td align='center' valign='middle' width=100 id="29" class="topmenu"><a href="javascript:showMenuDepth('29');" title='�ڵ�������'><b>�ڵ�������</b></a></td>
								<%}else if(str.equals("�ڵ����˻�")){%>
								<td align='center' valign='middle' width=100 id="31" class="topmenu"><a href="javascript:showMenuDepth('31');" title='�ڵ����˻�'><b>�ڵ����˻�</b></a></td>
								<%}else if(str.equals("���·�")){%>
								<td align='center' valign='middle' width=100 id="25" class="topmenu"><a href="javascript:showMenuDepth('25');" title='���·�'><b>���·�</b></a></td>
								<%}else if(str.equals("���Ź��")){%>
								<td align='center' valign='middle' width=100 id="26" class="topmenu"><a href="javascript:showMenuDepth('26');" title='���Ź��'><b>���Ź��</b></a></td>
								<%}else if(str.equals("Ź�۰���")){%>
								<td align='center' valign='middle' width=100 id="33" class="topmenu"><a href="javascript:showMenuDepth('33');" title='Ź�۰���'><b>Ź�۰���</b></a></td>
								<%}else if(str.equals("��ǰ����")){%>
								<td align='center' valign='middle' width=100 id="27" class="topmenu"><a href="javascript:showMenuDepth('27');" title='��ǰ����'><b>��ǰ����</b></a></td>
								<%}else if(str.equals("�ݼ�Ÿ")){%>
								<td align='center' valign='middle' width=100 id="28" class="topmenu"><a href="javascript:showMenuDepth('28');" title='�ݼ�Ÿ'><b>�ݼ�Ÿ</b></a></td>
								<%}else if(str.equals("����⵿")){%>
								<td align='center' valign='middle' width=100 id="32" class="topmenu"><a href="javascript:showMenuDepth('32');" title='����⵿'><b>����⵿</b></a></td>
								<%}else if(str.equals("������")){%>
								<td align='center' valign='middle' width=100 id="34" class="topmenu"><a href="javascript:showMenuDepth('34');" title='������'><b>������</b></a></td>
								<%}else if(str.equals("����������")){%>
								<td align='center' valign='middle' width=100 id="30" class="topmenu"><a href="javascript:showMenuDepth('30');" title='����������'><b>����������</b></a></td>
								<%}else if(str.equals("��������")){%>
								<td align='center' valign='middle' width=100 id="36" class="topmenu"><a href="javascript:showMenuDepth('36');" title='��������'><b>��������</b></a></td>
								<%}else if(str.equals("��������")){%>
								<td align='center' valign='middle' width=100 id="38" class="topmenu"><a href="javascript:showMenuDepth('38');" title='��������'><b>��������</b></a></td>
								<%}%>
                    		<%}%>
                    			<td>&nbsp;</td>
                            </tr>
                            <tr>
                            	
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