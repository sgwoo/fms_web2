<%@page import="org.omg.CORBA.portable.ValueBase"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*, acar.memo.*, acar.estimate_mng.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>

<%@ include file="/acar/cookies.jsp" %> 

<style>

.modal_bg {position:fixed;top:0;left:0;z-index:100;width:100%;height:95%;background-color:rgba(0,0,0,.5); margin-left: 164px;   text-align: center; line-height: 1em;  }
.modal_bg img { top: 7%; position: relative; display: inline-block; margin-top: 24px; left: -164px; }

</style>

<div class="modal_bg" id="modal_bg" name="modal_bg" >
	<img src="/images/viewLoading.gif" />
</div>

<%
	String acar_id = ck_acar_id;
	
	//로그아웃 처리를 위한------------------
	String login_time 	= Util.getLoginTime();		//로그인시간
	String ip 		= request.getRemoteAddr(); 	//로그인IP
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String m_st 	= request.getParameter("m_st")==null?"13":request.getParameter("m_st");
	String m_st2 	= request.getParameter("m_st2")==null?"01":request.getParameter("m_st2");
	String m_cd 	= request.getParameter("m_cd")==null?"01":request.getParameter("m_cd");
	String url 		= request.getParameter("url")==null?"":request.getParameter("url");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id 	= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	
    String cmd = "";
	int count = 0;
	int bbs_id = 0;
	
	//사용자정보
	UserMngDatabase umd = UserMngDatabase.getInstance();
	UsersBean user_bean = umd.getUsersBean(acar_id);
	
	//미수신된 메모확인
	MemoBean[] bns = memo_db.getRece_n_List(acar_id);
	
	//전체 공지사항 조회
	OffAncDatabase oad = OffAncDatabase.getInstance();
	AncBean a_r [] = oad.getAncFrameTop("", "", "", extStaffType );
	
	//스마트견적 대기건수
	int spe_cnt = 0;
	int mr_cnt = 0;
	int gst_cnt = 0;
	
	Vector bu_menu = new Vector();
	
	if( !isExtStaff ){
		EstiDatabase e_db = EstiDatabase.getInstance();
		spe_cnt = e_db.getSpeEstiCnt();
		mr_cnt = e_db.getMrentEstiCnt();
		gst_cnt = e_db.getGustEstiCnt();
	}
	
	if( isExtStaff ){
		//대메뉴
		bu_menu = umd.getAuthMaMeAllOffBMenu(acar_id);
		int bumenu_size = bu_menu.size();
	}
	
	//중메뉴
	Vector	 au_menu = umd.getAuthMaMeAll1(acar_id, m_st);
	int aumenu_size = au_menu.size();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	//바로가기메뉴리스트
	Vector qmenus = nm_db.getQLinkList(acar_id);
	int qmenu_size = qmenus.size();
	
	
	
	
%>

<html>
<head>
<META HTTP-EQUIV="refresh" CONTENT="3600">
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />

<title>:: FMS(Fleet Management System) ::</title>
<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script> --><!-- 수정 전 -->
<script src="/include/jquery-3.2.1.min.js"></script><!-- 수정 후 -->
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/sub.css">
<script language='javascript'>
<!--

	var isMiddleMenuInit = true;
	
	function pageInit(){
		close_modal_bg();
	}

	function close_modal_bg(){
		
		document.getElementById("modal_bg").style.display = "none";
	}
	
	function open_modal_bg(){
		document.getElementById("modal_bg").style.display = "block";
	}
	
	function page_link(m_st, m_st2, m_cd, url, auth_rw, isInit){	
	//function page_link(m_st, m_st2, isInit){
		
		parent.d_menu.open_modal_bg();
		
		var menu_tbl_id = "menu_depth_"+m_st;
		var fm = document.form1;	
		
		if(m_cd == '' || m_cd == null) m_cd = '01';
		if(url == '' || url == null) url = '';
		if(auth_rw == '' || auth_rw == null) auth_rw = '';
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		//var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		if(menu1 != menu2){
			//location.href 			= 'emp_top.jsp'+values;
		}
		
		if(isInit != null && isInit){
			middleMenuInit();
		}

		var submenus = null;
		
		if(typeof document.querySelectorAll != "undefined"){
			submenus = document.querySelectorAll( "#"+menu_tbl_id+" a" ); 
		}else{
			
			submenus = $("#"+menu_tbl_id+" a");
		
		}
		
		for( var i=0; i<submenus.length; i++ ){
			submenus[i].style.fontWeight  = 'normal';
		}

		var subObj = document.getElementById(m_st+m_st2);
	 	
		if( subObj != null ){
			document.getElementById(m_st+m_st2).style.fontWeight = 'bold';
		}else{
			//parent.d_content.location = url+''+values;		
		}
		
		parent.d_menu.location.href = 'emp_menu.jsp'+values;
	} 
		
	function showMenuDepth_2(m_st, m_st2){
		
		var menu_tbl_id = "menu_depth_"+m_st;

		middleMenuInit();
		
		parent.d_content.location = "about:blank";
		
		var domObj = document.getElementById(menu_tbl_id);
		
		if( domObj != null ){  
			domObj.style.display = "block";
		}
		
		isMiddleMenuInit = false;
		
		page_link(m_st, m_st2);
		
		isMiddleMenuInit = true;
	}
	
	function middleMenuInit(){
		
		var menus = null;
			
		if(typeof document.getElementsByClassName != "undefined"){
			menus = document.getElementsByClassName("menu_depth_2"); 
		}else{
			menus = $(".menu_depth_2" );
		}

		for( var i = 0; i<menus.length; i++ ){
			//menus[i].style.display="none";
			
			$(menus[i]).hide();
		}		
	}

	function tickerLink(m_st, m_st2, m_cd, url, auth_rw, isInit){
		showMenuDepth_2(m_st, m_st2);
		
		var fm = document.form1;			
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		
		parent.d_content.location = url+''+values;
		
	}
	//바로가기 메뉴 선택시
	function page_link2(){
	
		var fm = document.form1;

		var qlink = fm.qlink.options[fm.qlink.selectedIndex].value;
		
		if(qlink == ''){ return;}
		
		var qlinks = qlink.split(" ");
		
		var url     = "";
		var m_st 	= qlinks[0];
		var m_st2 	= qlinks[1];
		var m_cd 	= qlinks[2];
		var auth_rw	= qlinks[3];
		var url_l 	= qlinks[4];
		var url_s	= qlinks[5];	
		var folder 	= m_st+''+m_st2+''+m_cd;	


		if(fm.l_cd.value == '')		url = url_l;			
		else				url = url_s;
		
		
		var values 	= '?menu_st=quick&m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;
		
		if(folder == '040102' && fm.l_cd.value != '') values += '&s_st=3&s_kd=1&t_wd='+fm.l_cd.value;
		if(folder == '050301' && fm.l_cd.value != '') values += '&f_list=pay';
		if(folder == '050502' && fm.l_cd.value != '') values += '&f_list=scd';
		if(folder == '050701' && fm.l_cd.value != '') values += '&s_kd=2&t_wd1='+fm.l_cd.value;
		
		var menu1 	= fm.m_st.value;
		var menu2 	= m_st;	
		
		/**  2015.04.03 ywkim 수정  { **/
		values += "&isQmenu=true";

		parent.d_content.location = "about:blank";
		
		/** }  **/
		
		
		/* 20150403 메인페이지만 이동*/
		/*
		if(menu1 != menu2){			
			location.href 			= 'emp_top.jsp'+values;			
		}		
		parent.d_menu.location.href = 'emp_menu.jsp'+values;					
		*/
		
		showMenuDepth_2(m_st, m_st2);
		
		parent.d_content.location = url+''+values;			
	}
	
	//검색하기
	function search(){
		var fm = document.form1;	
		if(fm.q_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.q_wd.focus(); return; }	
		window.open("about:blank", "SEARCH", "left=100, top=100, width=870, height=550, scrollbars=yes");		
		fm.target = "SEARCH";
		fm.action = "./search_sh.jsp";
		fm.submit();					
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
	
	//메모보기
	function Memo(arg, cmd){
		var SUBWIN="/acar/memo/memo_frame.jsp?user_id="+arg+"&cmd="+cmd;	
		window.open(SUBWIN, "MemoUp", "left=10, top=10, width=650, height=650, scrollbars=yes");
	}	
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		i_no.location ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
	}
	//자동전표 관리페이지 팝업 -> iu전환후 미사용 
	function autodocu_mng(){
		//var SUBWIN="./autodocu_del.jsp";	
		//window.open(SUBWIN, "Autodocu", "left=50, top=50, width=850, height=450, scrollbars=yes, status=yes");		
	}
	//공지사항 1건 팝업 조회
	function Open(bbs_id, bbs_st){
		if(bbs_st == 5){  //경조사
			var SUBWIN="/fms2/off_anc/anc_c2.jsp?bbs_id="+bbs_id;
		}else{ //일반
			var SUBWIN="/fms2/off_anc/anc_se_c.jsp?bbs_id="+bbs_id;
		}
		window.open(SUBWIN, "AncDisp", "left=100, top=50, width=1024, height=800, scrollbars=yes");
	}	
	//사용자정보 팝업
	function UserUpdate(arg){
		
		var isExtStaff = <%=isExtStaff %>;
		var SUBWIN="./info_u.jsp?user_id="+arg;
		var height = 650;
		
		if(isExtStaff){
			SUBWIN="/off/menu/info_u.jsp?user_id="+arg;
			height = 350;
		}

		window.open(SUBWIN, "InfoUp", "left=100, top=10, width=500, height="+height+", scrollbars=yes");
	}
	//계산서 메인 팝업
	function tax_open(){
		var s_width = screen.width;
		var s_height = screen.height;
		var SUBWIN="/tax/menu/tax_frame.jsp?s_width="+s_width+"&s_height="+s_height;
		newwin=window.open("","TAX","scrollbars=yes, status=yes, resizable=1");
		if (document.all){
			newwin.moveTo(0,0);
			newwin.resizeTo(screen.width,screen.height-50);
		}	
		newwin.location=SUBWIN;	
	}	
	//법인카드 메인 팝업
	function card_open(){
		var s_width = screen.width;
		var s_height = screen.height;
		var SUBWIN="/card/menu/card_frame.jsp?s_width="+s_width+"&s_height="+s_height;
		newwin=window.open("","CARD","scrollbars=yes, status=yes, resizable=1");
		if (document.all){
			newwin.moveTo(0,0);
			newwin.resizeTo(screen.width,screen.height-50);
		}	
		newwin.location=SUBWIN;
	}		
	//메일 메인 팝업
//	function mail_open(){
//		var s_width = screen.width;
//		var s_height = screen.height;
//		var SUBWIN="http://mail.amazoncar.co.kr/main.php?domain=amazoncar.co.kr&userid=<%=user_bean.getMail_id()%>&passwd=<%=user_bean.getMail_pw()%>";
//		newwin=window.open("","MAIL","scrollbars=yes, status=yes, resizable=1");
//		if (document.all){
//			newwin.moveTo(0,0);
//			newwin.resizeTo(screen.width,screen.height-50);
//		}	
//		newwin.location=SUBWIN;
//	}		

	
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
	
//	function mail_open(){
//		var s_width = screen.width;
//		var s_height = screen.height;
//		var SUBWIN="http://mail.amazoncar.co.kr/login.php?template_language=korean&login_host=amazoncar.co.kr&login_type=U&login_id=<%=user_bean.getMail_id()%>@amazoncar.co.kr&login_passwd=<%=user_bean.getMail_pw()%>";
//		newwin=window.open("","MAIL","scrollbars=yes, status=yes, resizable=1");
//		if (document.all){
//			newwin.moveTo(0,0);
//			newwin.resizeTo(screen.width,screen.height-50);
//		}	
//		newwin.location=SUBWIN;
//	}	
	
	
	function open_client_search(){
		var SUBWIN="/fms2/client/client_search.jsp";	
		window.open(SUBWIN, "MailUp", "left=3, top=50, width=1000, height=600, scrollbars=yes");
	}
	function open_smsgate(){
		var fm = document.form1;
		var values 	= '&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value+'&m_id='+fm.m_id.value+'&l_cd='+fm.l_cd.value+'&c_id='+fm.c_id.value+'&rent_mng_id='+fm.m_id.value+'&rent_l_cd='+fm.l_cd.value+'&car_mng_id='+fm.c_id.value+'&client_id='+fm.client_id.value+'&accid_id='+fm.accid_id.value+'&serv_id='+fm.serv_id.value+'&seq_no='+fm.seq_no.value;			
		var SUBWIN="/acar/sms_gate/sms_gate_pop.jsp?m_st=12&m_st2=01&m_cd=01&auth_rw=6"+values;	
		//window.open(url, "pop", "menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
		window.open(SUBWIN, "pop", "left=3, top=50, width=900, height=900, menubar=yes, toolbar=yes, location=yes, directories=yes, status=yes, scrollbars=yes, resizable=yes");
	}
	
	//연락망
	function tel(){
		var SUBWIN="/acar/user_mng/sostel_frame.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=800, height=700, scrollbars=yes");
	}	
	
	//연락망
	function tel2(){
		var SUBWIN="/acar/user_mng/sawon2.jsp";	
		window.open(SUBWIN, "TelUp", "left=10, top=10, width=700, height=700, scrollbars=yes");
	}	
	
				
//-->
</script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<style>


#so_oTickerContainer {
    width:300px;
    margin:auto;
    font:verdana,arial;
    background-color:;
    border-top:;
    border-bottom:;
}

#so_oTickerContainer h1 {
    font:bold verdana,arial;
    margin:0;
    padding:0;
}
    
.so_tickerContainer {
    position:relative;
    margin:auto;
    width:300px;
    background-color:;
    border-top:;
    border-bottom:;
}

#so_tickerAnchor, #so_oTickerContainer a {
    text-decoration:none;
    color:black;
    font:bold arial,verdana;
    border-right:;
    padding-right:;
}

#so_oTickerContainer a {
    border-style:none;
}

#so_oTickerContainer ul {
    margin-top:5px;
}

#so_tickerDiv {
    display:inline;
    margin-left:5px;
}

#so_tickerH1 {
    font:bold 1.0em arial,verdana;
    display:inline;
}

.so tickerP1 {
 	color:red;
    font:bold 1.0em arial,verdana;
}   
    
#so_tickerH1 a {
    text-decoration:none;
    color:none;
    padding-right:none;
}

#so_tickerH1 a img {
    border-style:none;
}
<!--
.style2 {color: #ff00ff;
         font-size: 11px;}
.style3 {color: #FF0000}
-->
</style>
<script>
/* This script and many more are available free online at
The JavaScript Source!! http://javascript.internet.com
Created by: Steve Chipman | http://slayeroffice.com/Licensed under: Creative Commons License
*/

/****************************

so_ticker
version 1.0
last revision: 03.30.2006
steve@slayeroffice.com

For implementation instructions, see:
http://slayeroffice.com/code/so_ticker/

Should you improve upon or modify this
code, please let me know so that I can update
the version hosted at slayeroffice.

Please leave this notice intact.


****************************/

so_ticker = new Object();
so_ticker = {
    current:0,            
    currentLetter:0,    
    zInterval:null,    
    tObj: null,            
    op:0.95,            
    pause: false,        
    tickerContent: [],    
    LETTER_TICK:100, 
    FADE: 10, 
    NEXT_ITEM_TICK: 3000, 
    init:function() {
        var d=document;    
        var mObj = d.getElementById("so_oTickerContainer");    
        so_ticker.tObj = d.createElement("div");        
        so_ticker.tObj.setAttribute("id","so_tickerDiv"); 
        var h = d.createElement("h1");    
        h.appendChild(d.createTextNode(so_ticker.getTextNodeValues(mObj.getElementsByTagName("h1")[0])));    
        h.setAttribute("id","so_tickerH1");    
        var ea = d.createElement("a");
 //       ea.setAttribute("href","javascript:so_ticker.showContent();");
        pImg = ea.appendChild(document.createElement("img"));
        pImg.setAttribute("src","/images/new.gif");
        pImg.setAttribute("alt","");
        ea.setAttribute("title","");
        h.insertBefore(ea,h.firstChild);
        anchors = mObj.getElementsByTagName("a");     
           
        var nObj = mObj.cloneNode(false);        
        mObj.parentNode.insertBefore(nObj,mObj); 
        mObj.style.display = "none";    
        nObj.className = "so_tickerContainer";     
        nObj.setAttribute("id","so_nTickerContainer");
        nObj.appendChild(h);     
        nObj.appendChild(so_ticker.tObj);    
        so_ticker.getTickerContent();    
        so_ticker.zInterval = setInterval(so_ticker.tick,so_ticker.LETTER_TICK);     
    },
    showContent:function() {
            var d = document;
            d.getElementById("so_oTickerContainer").style.display = "block"; 
            d.getElementById("so_nTickerContainer").style.display = "none";
            d.getElementById("so_oTickerContainer").getElementsByTagName("a")[0].focus();
            clearInterval(so_ticker.zInterval);
    },
    getTickerContent:function() {
        for(var i=0;i<anchors.length;i++) so_ticker.tickerContent[i] = so_ticker.getTextNodeValues(anchors[i]);
    }, 
    getTextNodeValues:function(obj) {
        if(obj.textContent) return obj.textContent;
        if (obj.nodeType == 3) return obj.data;
        var txt = [], i=0;
        while(obj.childNodes[i]) {
            txt[txt.length] = so_ticker.getTextNodeValues(obj.childNodes[i]);
            i++;
        }
        return txt.join("");
    },
    tick: function() {
        var d = document;
        if(so_ticker.pause) {
            try {
                so_ticker.clearContents(d.getElementById("so_tickerAnchor"));
                d.getElementById("so_tickerAnchor").appendChild(d.createTextNode(so_ticker.tickerContent[so_ticker.current]));
                so_ticker.currentLetter = so_ticker.tickerContent[so_ticker.current].length;
            } catch(err) { }
            return;
        }
        if(!d.getElementById("so_tickerAnchor")) {
            var aObj = so_ticker.tObj.appendChild(d.createElement("a"));
            aObj.setAttribute("id","so_tickerAnchor");
            aObj.setAttribute("href",anchors[so_ticker.current].getAttribute("href"));
            aObj.onmouseover = function() { so_ticker.pause = true; }
            aObj.onmouseout = function() { so_ticker.pause = false; }
            aObj.onfocus = aObj.onmouseover;
            aObj.onblur = aObj.onmouseout;
            aObj.setAttribute("title",so_ticker.tickerContent[so_ticker.current]);
        }
        d.getElementById("so_tickerAnchor").appendChild(d.createTextNode(so_ticker.tickerContent[so_ticker.current].charAt(so_ticker.currentLetter)));
        so_ticker.currentLetter++;
        if(so_ticker.currentLetter > so_ticker.tickerContent[so_ticker.current].length) {
            clearInterval(so_ticker.zInterval);
            setTimeout(so_ticker.initNext,so_ticker.NEXT_ITEM_TICK);
        }
    },
    fadeOut: function() {
        if(so_ticker.paused) return;
        so_ticker.setOpacity(so_ticker.op,so_ticker.tObj);
        so_ticker.op-=.10;
        if(so_ticker.op<0) {
            clearInterval(so_ticker.zInterval);
            so_ticker.clearContents(so_ticker.tObj);
            so_ticker.setOpacity(.95,so_ticker.tObj);
            so_ticker.op = .95;
            so_ticker.zInterval = setInterval(so_ticker.tick,so_ticker.LETTER_TICK);
        }
    },
    initNext:function() {
            so_ticker.currentLetter = 0, d = document;
            so_ticker.current = so_ticker.tickerContent[so_ticker.current + 1]?so_ticker.current+1:0;
            d.getElementById("so_tickerAnchor").setAttribute("href",anchors[so_ticker.current].getAttribute("href"));
            d.getElementById("so_tickerAnchor").setAttribute("title",so_ticker.tickerContent[so_ticker.current]);
            so_ticker.zInterval = setInterval(so_ticker.fadeOut,so_ticker.FADE);
    },
    setOpacity:function(opValue,obj) {
        obj.style.opacity = opValue;
        obj.style.MozOpacity = opValue;
        obj.style.filter = "alpha(opacity=" + (opValue*100) + ")";
    },
    clearContents:function(obj) {
        try {
            while(obj.firstChild) obj.removeChild(obj.firstChild);
        } catch(err) { }
    }
}
<% if( !isExtStaff ) { %>
<%if( !nm_db.getWorkAuthUser("스마트견적미표시",acar_id)  && ( spe_cnt>0 || gst_cnt >0) ){%> 
function page_init(){
    so_ticker.init();
}
window.addEventListener?window.addEventListener("load",page_init,false):window.attachEvent("onload",page_init);
<% }} %>
</script>

<script type="text/javascript">
		$(document).ready(function() {
			var current = -1;
			var elems = new Array();
			var elems_i = 0;
			$('.items').each(function() {
				elems[elems_i++] = $(this);
			});
			
			if( elems != null && elems.length > 0 ){
				var num_elems = elems_i - 1;
				var animate_out = function() {
					elems[current].animate({ top: '-100px' }, 'slow', 'linear', animate_in);
				};
				
				var animate_out_delay = function() {
					setTimeout(animate_out, 3000); /*2000=2초*/
				};
				
				var animate_in = function() {
					current = current < num_elems ? current + 1 : 0;
					elems[current].css('top', '200px').animate({ top: '0px' }, 'slow', 'linear', animate_out_delay);
				};
				
				animate_in();
			}
		});
	</script>
 
   <style type="text/css">
		.ticker {
			position: relative; /* So we can absolute the .items */
			width: 400px;
			height: 19px;
			overflow: hidden;
			
		}
		.items {
			position: absolute;
			top: 20px;
			margin:0 0 0 70px;
			font-family:돋움;
			font-size:12px;
			
		}
	</style>
	
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="javascript:pageInit();" >

<form name="form1" method="post" action="">
<input type='hidden' name="m_st" value="<%=m_st%>">
<input type='hidden' name="m_st2" value="<%=m_st2%>">
<input type='hidden' name="m_cd" value="<%=m_cd%>">
<input type='hidden' name="url" value="<%=url%>">
<input type='hidden' name="auth_rw" value="<%=auth_rw%>">
<input type='hidden' name="user_id" value="<%=acar_id%>">
<input type='hidden' name='br_id' value="<%=user_bean.getBr_id()%>">
<input type='hidden' name='m_id' value="<%=m_id%>">
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name="accid_id" value="<%=accid_id%>">
<input type='hidden' name="serv_id" value="<%=serv_id%>">
<input type='hidden' name="seq_no" value="<%=seq_no%>">
<input type='hidden' name="s_width" value="<%=s_width%>">
<input type='hidden' name="s_height" value="<%=s_height%>">
<table width=100% border=0 cellspacing=0 cellpadding=0>
    <tr>
        <td width=169 height=49 align=center background=/acar/images/top_bg.gif><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src=/acar/images/logo_1.png width="130px"></a></td>
        <td valign=top background=/acar/images/top_bg.gif>
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td>
                        <table width=100%  border=0 cellspacing=0 cellpadding=0>
                            <tr>                                
								<%if(!isExtStaff && !nm_db.getWorkAuthUser("스마트견적미표시",acar_id)  && ( spe_cnt>0 || gst_cnt >0 || mr_cnt >0) ){%>  
	                                <td align=right style="font-family:돋움"; "font-size=8pt";>
	                                			<%if(!ck_acar_id.equals("000000") && !nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>
													<div id="so_oTickerContainer">
														<h1></h1>
														<ul>															    
															<%if(spe_cnt > 0 ){%><a href="javascript:tickerLink('01','05','01','/acar/estimate_mng/esti_spe_hp_frame.jsp','<%=rs_db.getAuthRw(acar_id, "01", "05", "01")%>');">스마트견적<b><span id="so tickerP1"><%=spe_cnt%>건</span></b></a><%}%>&nbsp;
															<%if(gst_cnt > 0 ){%><a href="javascript:tickerLink('01','05','12','/fms2/biz_tel_mng/guest_frame.jsp','<%=rs_db.getAuthRw(acar_id, "01", "05", "12")%>');">고객상담요청<b><span id="so tickerP1"><%=gst_cnt%>건</span></b></a><%}%>&nbsp;
															<%if(mr_cnt > 0 ){%><a href="javascript:tickerLink('01','05','01','/acar/estimate_mng/esti_spe_hp_frame.jsp','<%=rs_db.getAuthRw(acar_id, "01", "05", "01")%>');">월렌트견적<b><span id="so tickerP1"><%=mr_cnt%>건</span></b></a><%}%>&nbsp;
														</ul>
													</div>
												<%}%>	
										&nbsp;
									</td>
								<%}else{%>
									<td width=1500>&nbsp;</td>
								<%}%>
                               	<td width=10>&nbsp;</td>
                                <!--메인  화면--><td width=48><!--<a href="/acar/main.jsp" target=_parent>--><a href="../menu/emp_frame.jsp" target=_parent title="메인화면-공지사항"><img src=/acar/images/top_b_home.gif width=48 height=14 border=0></a></td>
                                <%if(!acar_id.equals("000000") && !nm_db.getWorkAuthUser("아마존카이외",acar_id) && !isExtStaff ){%>                               
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--공지사항--><td width=58><a href="javascript:showMenuDepth_2('13','01','','','', true);"><img src=/acar/images/top_b_notice.gif width=58 height=14 border=0></a></td>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--전자문서--><td width=57><a href="javascript:showMenuDepth_2('15','01','','','', true);"><img src=/acar/images/top_b_edoc.gif width=57 height=14 border=0></a></td>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--자 료 실--><td width=47><a href="javascript:showMenuDepth_2('14','01','','','', true);"><img src=/acar/images/top_b_dw.gif width=47 height=14 border=0></a></td>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                
	                                <!--S  M  S --><td width=42><a href="javascript:showMenuDepth_2('12','01','','','');"><img src=/acar/images/top_b_sms.gif width=42 height=14 border=0></a></td>                                
                               		<td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
                               		<!--명함관리-->
	                                <td width=42><a href="javascript:showMenuDepth_2('35','01','','','',true);"><img src=/acar/images/top_b_card.gif border=0></a></td>       
                                <%}%>
                                          
                                <%if(nm_db.getWorkAuthUser("전산팀",acar_id) || acar_id.equals("000004") || acar_id.equals("000048")){%>
	                                <!--ADMIN   -->
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <td width=52><a href="javascript:showMenuDepth_2('99','01','','','')"><img src=/acar/images/top_b_admin.gif width=52 height=14 border=0></a>
									</td>
                                <%}%>
                                
                                <%if(!acar_id.equals("000000") && !nm_db.getWorkAuthUser("아마존카이외",acar_id) && !isExtStaff){%>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!-- 사이트맵 --><td width=57><a href="/acar/sitemap/sitemap.jsp?auth_rw=<%=auth_rw%>&user_id=<%=acar_id%>&br_id=<%=user_bean.getBr_id()%>" target=d_content title=사이트맵><img src=/acar/images/top_b_smap.gif border=0></a></td>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--고객 FMS--><td width=49><a href="javascript:showMenuDepth_2('18','01','','','');"><img src=/acar/images/top_b_cfms.gif border=0></a></td>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!-- 표준월대여료 --><td width=57><a href="javascript:var win=window.open('/acar/main_car_hp/r_estimate.jsp','popup','left=10, top=10, width=1200, height=800, status=no, scrollbars=yes, resizable=yes');"><img src=/acar/images/top_b_fee.gif border=0></a></td>
	                                <!--<td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                 자동차연비 <td width=57><a href="http://bpms.kemco.or.kr/transport_2012/main/main.aspx" target=_blank><img src=/acar/images/top_b_yb.gif border=0></a></td>-->
                                <%}%>
                                
                                <% if( isExtStaff && acar_de.equals("1000") ){ %>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--공지사항-->
	                                <td width=58 height="30">
	                                	<a href="/off/off_bbs/off_bbs_frame.jsp?auth_rw=&user_id=<%=ck_acar_id %>&br_id=<%=acar_br %>" target="d_content" >
	                                		<img src=/acar/images/top_b_notice.gif width=58 height=14 border=0 />
	                                	</a>
                                	</td>
									<td width=1>
										<img src=/acar/images/top_b_vline.gif width=1 height=14>
									</td>
	                                <!-- 표준월대여료 -->
	                                <td width=57>
	                                	<a href="javascript:var win=window.open('/acar/main_car_hp/r_estimate.jsp','popup','left=10, top=10, width=1200, height=800, status=no, scrollbars=yes, resizable=yes');">
	                                		<img src=/acar/images/top_b_fee.gif border=0>
                                		</a>
                               		</td>
	                                <td width=1>
	                                	<img src=/acar/images/top_b_vline.gif width=1 height=14>
                                	</td>
	                                <!-- 자동차연비 -->
	                                <td width=57>
	                                	<a href="http://bpms.kemco.or.kr/transport_2012/main/main.aspx" target=_blank>
	                                		<img src=/acar/images/top_b_yb.gif border=0>
                                		</a>
                               		</td>
								<% } %>
								                                
                                <% if( isExtStaff && acar_de.equals("8888") ){ %>
	                                <td width=1><img src=/acar/images/top_b_vline.gif width=1 height=14></td>
	                                <!--공지사항-->
	                                <td width=58 height="30">
	                                	<a href="/off/off_bbs/off_bbs_frame.jsp?auth_rw=&user_id=<%=ck_acar_id %>&br_id=<%=acar_br %>" target="d_content" >
	                                		<img src=/acar/images/top_b_notice.gif width=58 height=14 border=0 />
	                                	</a>
                                	</td>                                
								<% } %>
                                <td width=5>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    
                    <% if( !isExtStaff ){ %>
                    
                    <td width=197>
                        <table width=197 border=0 cellpadding=0 cellspacing=0 background=/acar/images/quick_bg.gif>
                            <tr>
                                <td width=4 height=30><img src=/acar/images/quick_1.gif width=4 height=30></td>
                                <td width=64 align=center><img src=/acar/images/quick_2.gif width=58 height=10></td>
                                <td>
                                    <select name="qlink" onChange="javascript:page_link2()" style='height:19px'>
                                        <option value="">바로가기--------</option>
                        				<option value=""></option>
                        			<%	//바로가기 리스트 조회
                        				for (int i = 0 ; i < qmenu_size ; i++){
                        					Hashtable qmenu = (Hashtable)qmenus.elementAt(i);%>
                                        <option value="<%=qmenu.get("URL")%>"><%=qmenu.get("M_NM")%></option>					
                        			<%	}%>
                                  </select>
                                     <%// }%>  </td>
                                     <!--빠른조회
                                  <td width="56" height="30"><img src="../images/sub/sub_search_02.gif"></td>
                                    <td width="54"> 
                                      <select name="q_kd1" style='width:49px; height:19px'>
                                        <option value="1">계약</option>
                                        <option value="2">차량</option>
                                      </select>
                                    </td>
                                    <td width="80"> 
                                      <select name="q_kd2" style='width:79px; height:19px'>
                                        <option value="1">상호</option>
                                        <option value="2" selected>차량번호</option>
                                      </select>
                                    </td>
                                    <td width="120"> 
                                      <input type="text" name="q_wd" size="15" class=text onKeyDown="javasript:enter()" style='height:17px'>
                                    </td>
                                    <td width="38" height="19"><a href='javascript:search()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="../images/sub/sub_search_but.gif" border="0"></a></td>
                        			-->
                                <td width=4><img src=/acar/images/quick_3.gif width=4 height=30></td>
                            </tr>
                        </table>
                    </td>
                    <% } %>
                    <td width=8>&nbsp;</td>
                </tr>
                <tr><!-- 공지사항 뉴스티커 -->
                    <td colspan=3 class="ticker">&nbsp;&nbsp;&nbsp;					
						<img src=/acar/images/icon_notice.gif>
						<%	for(int i=0; i<a_r.length; i++){
							a_bean = a_r[i];
							if(a_bean.getBbs_st().equals("7")) continue; %>
						<%	if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>
								<div class="items">
									<font color="Fuchsia" size="1">
										<b>New</b>
									</font>&nbsp;
									<font size="2" family="굴림,Gulim, AppleGothic, Seoul, Arial">
										<a href="javascript:Open(<%=a_bean.getBbs_id()%>,<%=a_bean.getBbs_st()%>)" title="<%=a_bean.getTitle()%>">
											<%if(a_bean.getRead_yn().equals("Y")){%>
												<img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;
											<%}%>
											<%=Util.subData(a_bean.getTitle(),35)%> 
										</a>
									</font>
								</div>
						<%	}else{%>
								<div class="items"><font size="2" family="굴림,Gulim, AppleGothic, Seoul, Arial"><a href="javascript:Open(<%=a_bean.getBbs_id()%>,<%=a_bean.getBbs_st()%>)" title="<%=a_bean.getTitle()%>"><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><%=Util.subData(a_bean.getTitle(),35)%></a></font></div>
						<%	}%>
						
						<%	}%>
					</td>
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
                                            <td>&nbsp;<strong><%=user_bean.getUser_nm()%></strong>
                                <!--전표삭제--><!--<%if(nm_db.getWorkAuthUser("회계업무",acar_id)){%>&nbsp;&nbsp;<a href="javascript:autodocu_mng();" title="자동전표삭제">.</a>--><%}%>
        		                <!--고객조회--><%if(nm_db.getWorkAuthUser("내근직",acar_id) || user_bean.getUser_pos().equals("사원") || user_bean.getUser_pos().equals("대리") || user_bean.getUser_pos().equals("과장") || user_bean.getUser_nm().equals("허승범")){%><a href="javascript:open_client_search();" title="거래처조회">.</a>&nbsp;<a href="javascript:open_smsgate();" title="SMS발송">.</a><%}%></td>
        		                        </tr>
        		                    </table>
        		                </td>
                 <!--Logout  --><td width=49><a href="javascript:Logout();"><img src=/acar/images/button_logout.gif width=49 height=14 border=0></a></td>
                            </tr>
                        </table>
                    </td>
                    <td width=4 rowspan=2><img src=/acar/images/menu_left.gif width=4 height=75></td>
                </tr>
                <tr>
                    <td height=47 align=center valign=top>
                        <table width=144 border=0 cellspacing=0 cellpadding=0>
                        	<%
                        		boolean isMemo = bns.length > 0 ? true : false;
								
                        		String newMsg = isMemo ? "new" : "";
                        		String titleMsg = isMemo ? "새 메세지가 도착했습니다." : "메시지 보기";
                        		String notNew = "";
                        		String memoImg = "<img src=/acar/images/button_memo.gif width=17 height=10 border=0>";
                        		String memoEtc = " width=17 ";
                        		String telFn = "tel(); ";
                        		
                        		if( isMemo ){
                        			memoImg = "<img src=/acar/images/new.gif width=22 height=7>(" + bns.length + ")";
                        			memoEtc = " width=37 style='font-size:8pt' ";
                        		}
                        		
                        		if(isExtStaff){
                        			telFn = "tel2(); ";
                        		}
                        		
                        		String btnUserInfo = "<td width=38 height=23 align=right><a href=javascript:UserUpdate('"+acar_id+"') title=개인정보수정><img src=/acar/images/button_m.gif width=34 height=10 border=0></a></td>";
                        		String btnMemo = "<td "+memoEtc+"><a href=javascript:Memo('"+acar_id+"','"+newMsg+"'); title='"+titleMsg+"'>"+memoImg+"</a></td>";
                        		String btnMail = "<td width=17><a href=javascript:mail_open(); title='메일확인'><img src=/acar/images/button_mail.gif width=17 height=10 border=0></a></td>";
                        		String btnTel = "<td><a href=javascript:"+telFn+"><img src=/acar/images/button_tel.gif border=0></a></td>";
                        		String line = "<td width=9 align=center><img src=/acar/images/pro_vline.gif width=1 height=10></td>";
                        	%>
                            <tr>
								<%if(!acar_id.equals("000000") && !nm_db.getWorkAuthUser("아마존카이외",acar_id) && !isExtStaff){%>
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
								<% 
								}else{
									if( isExtStaff ){
										out.println(btnUserInfo);
										out.println(line);
										
										out.println(btnTel);
										
									}
								}%>
                                
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
                              <%
                              	HashMap<String, Object> map = Util.getDepthMenuInfo(acar_de);
                              
                              	String[][] MENU_DEPTH_1 = (String[][])map.get("menu");
                              	String sep = (String)map.get("menuSearator");
                              	String num = "";
                              	
                              	if( !isExtStaff ){
                              	for (int i=0; i < MENU_DEPTH_1.length ; i++  ){
                              		num = (i+1) < 10 ? ("0"+ Integer.toString(i+1)) : Integer.toString(i+1); 

                              		boolean isView = Boolean.parseBoolean(MENU_DEPTH_1[i][2]);
                              		
                              		if( isView ){
							  %>
                              	<td valign=middle <%= isExtStaff ? "width=100" : "" %> >
                              		<a href="javascript:showMenuDepth_2('<%=MENU_DEPTH_1[i][0] %>','<%=MENU_DEPTH_1[i][1] %>','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image<%= num %>','','/acar/images/menu_<%= num %>_1.gif',1)>
										<img src=/acar/images/menu_<%= num %>.gif name=Image<%= num %> border=0>
									</a>
								</td>
                              <% }
								}
							}else{
								
								MENU_DEPTH_1 = new String[bu_menu.size()][4];
								sep = "";
							%>
                              <%
                              	for (int i = 0 ; i < bu_menu.size() ; i++){
									Hashtable bumenu = (Hashtable)bu_menu.elementAt(i);
									
									sep += bumenu.get("M_ST") + ",";
									String[] m_st_info = { (String)bumenu.get("M_ST"), (String)bumenu.get("M_ST2"), "true", "" };
									
									MENU_DEPTH_1[i] = m_st_info;
									
							  %>
                              	<td width="100" valign=middle>
                              		<a href="javascript:showMenuDepth_2('<%=bumenu.get("M_ST")%>','<%=bumenu.get("M_ST2")%>','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image1','','/acar/images/menu_01_1.gif',1) >
	                              		<font color=white>
		                              		<b>
		                              			<%=bumenu.get("M_NM")%>
		                              		</b>
	                              		</font>
                              		</a>
                           		</td>
                              <%
                              	}
                              
                              if( sep.length() > 0 ){
                              	sep = sep.substring(0, sep.length() - 1);
                              }
                              %>
                           <% } %>							
							  <td>&nbsp;</td>
                    		  <td width="20">&nbsp;</td>
                    		  <td width="20">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                    	<% 
                    		int rownum = 0;
                    		for( int k = 0; k < MENU_DEPTH_1.length; k++  ){
                    		    
                    			num = (k+1) < 10 ? ("0"+ Integer.toString(k+1)) : Integer.toString(k+1);
                    			String style = "none";
                    			
                    			if(sep.indexOf(m_st) != -1 ){
                    				style = ( MENU_DEPTH_1[k][0].toString().trim().equals(m_st.trim()) ) ? "block" : "none";
                    			}else{
									style = k == 0 ? "block" : "none";
                    			}
                    	%>
	                        <!--2 depth menu  권한 시작 -->
	                        
	                        <table width="100%" border="0" cellspacing="0" cellpadding="0" background="/acar/images/menu_bg_2depth.gif" id="menu_depth_<%=MENU_DEPTH_1[k][0] %>" class="menu_depth_2" style="display:<%=style %>" name="menu_depth_2"  >
	                            <tr> 
	                                <td width=27 height=28>&nbsp;</td>

	                        <%	int t_width = 0;
	                        	for (int i = 0 ; i < aumenu_size ; i++){
	                        		
	                        		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                        		    
	                        		if((aumenu.get("M_ST").toString().trim()).equals((MENU_DEPTH_1[k][0].toString().trim())) ){
	                        		String str = aumenu.get("M_NM").toString();
	                        
	                        		int char_len = str.length();
	                        		int byte_len = str.getBytes().length;
	                        		int width = byte_len*8;//한글자에8pix=width
	                        		t_width += width;
	                        %>
	                        		<%if(i > 0){%>
	                                <td width="1" background="/acar/images/menu_bg_2depth.gif">
	                                	<img src="/acar/images/menu_2depth_vline.gif">
                                	</td>
	                            	<%}%>
	                            	<%if(m_st2.equals(aumenu.get("M_ST2"))){%>
	                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif" height=28>
	                                	<a id="<%=aumenu.get("M_ST")%><%=aumenu.get("M_ST2")%>" href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');" style="font-weight: bold" >
	                                		<%=aumenu.get("M_NM")%>
	                                	</a>
                                	</td>
	                            	<%}else{%>
	                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif"  height=28>
	                                	<a id="<%=aumenu.get("M_ST")%><%=aumenu.get("M_ST2")%>" href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');">
	                                		<%=aumenu.get("M_NM")%>
	                                	</a>
                                	</td>
	                            	<%}%>
	                        <%	}}%>
	                                <%if((AddUtil.parseInt(s_width)-165-30-t_width) >0){%>
									<td width="<%=(AddUtil.parseInt(s_width)-165-30-t_width)/AddUtil.parseInt(s_width)*100%>" background="../images/sub/sub_top_bg08.gif"></td>
									<%}else{%>
									<td width="1" background="../images/sub/sub_top_bg08.gif"></td>								
									<%}%>
	                                <td background="/acar/images/menu_bg_2depth.gif" align="right">&nbsp;</td>
	                            </tr>
	                        </table>
                        <% } %>
                        <!--2 depth menu  권한 끝 -->
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
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<Script Language="Javascript">
<!--
//공지사항 상단에 순서대로 반복 출력하기---------------------------------------------------
/*
var NS4 = (document.layers) ? true : false;
var IE4 = (document.all) ? true : false;
var interval = 30;
var increment = 1;
var pause = 2500;
var leftPadding = 5;
var topPadding = 5;
var bannerColor = "";
var bannerLeft = 220;
var bannerTop = 23;
//var bannerWidth = 350;
var bannerWidth = 650;
var bannerHeight = 25;

var ar = new Array(
<%	for(int i=0; i<a_r.length; i++){
    	a_bean = a_r[i];
		if(a_bean.getBbs_st().equals("7")) continue; %>
<%		if(a_bean.getReg_dt().equals(AddUtil.getDate())){ %>
  			'&nbsp;<font color="Fuchsia" size="1"><b>New</b></font>&nbsp;<font size="2" family="굴림,Gulim, AppleGothic, Seoul, Arial"><a href="javascript:Open(<%=a_bean.getBbs_id()%>,<%=a_bean.getBbs_st()%>)" title="<%=a_bean.getTitle()%>"><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><%=Util.subData(a_bean.getTitle(),35)%> </a></font>',
<%		}else{%>
			'&nbsp;<font size="2" family="굴림,Gulim, AppleGothic, Seoul, Arial"><a href="javascript:Open(<%=a_bean.getBbs_id()%>,<%=a_bean.getBbs_st()%>)" title="<%=a_bean.getTitle()%>"><%if(a_bean.getRead_yn().equals("Y")){%><img src="/images/n_icon.gif" border=0 align=absmiddle>&nbsp;<%}%><%=Util.subData(a_bean.getTitle(),35)%></a></font>',
<%		}%>
<%	}%>
'');

<%if(!ck_acar_id.equals("000000") && !nm_db.getWorkAuthUser("아마존카이외",ck_acar_id)){%>
//onload = startBanner;
<%}%>

function showMessage(n, show) {
  	var whichEl = (NS4) ? eval("message" + n) :
                          eval("message" + n + ".style");
  	whichEl.visibility = (show) ? ((NS4) ? "show" : "visible") :
                                  ((NS4) ? "hide" : "hidden");
}

function nextMessage() {
	var fromInd = current;
  	current = (fromInd == ar.length - 1) ? 0 : fromInd + 1;
  	scrollBanner(fromInd, current);
}

function moveUp() {
  	if (NS4) {
    	fromEl.top -= increment;
   		if (toEl.top - increment <= toElTarget) {
      		toEl.top = toElTarget;
      		clearInterval(intervalID);
      		fromEl.visibility = "hide";
      		timeoutID = setTimeout("nextMessage()", pause);
    	} else {
      		toEl.top -= increment;
    	}
  	} else {
    	fromEl.pixelTop -= increment;
    	if (toEl.pixelTop - increment <= toElTarget) {
      		toEl.pixelTop = toElTarget;
      		clearInterval(intervalID);
      		fromEl.visibility = "hidden";
      		timeoutID = setTimeout("nextMessage()", pause);
    	} else {
      		toEl.pixelTop -= increment;
    	}
  	}
}

function scrollBanner(from, to) {
  	if (NS4) {
    	fromEl = eval("message" + from);
    	toEl = eval("message" + to);
    	toEl.top = fromEl.top + bannerHeight;
    	toElTarget = fromEl.top;
  	} else {
    	fromEl = eval("message" + from + ".style");
    	toEl = eval("message" + to + ".style");
    	toEl.pixelTop = fromEl.pixelTop + bannerHeight;
    	toElTarget = fromEl.pixelTop;
  	}
  	showMessage(to, true);
  	intervalID = setInterval("moveUp()", interval);
}

function makeIE() {
 	var text = '<DIV ID="banner" STYLE="position:absolute; top:23px; left: 220px">';
  	for (var i = ar.length - 1; i >= 0; i--) {
    	text += '<DIV ID="message' + i + 
                '" STYLE="position:absolute"></DIV>';
  	}
  	text += '</DIV>';

 	document.body.insertAdjacentHTML("BeforeEnd", text);
	//document.body.appendChild( document.createTextNode(text) );
	//document.body.innerHTML += text;

  	with (banner.style) {
    	width = bannerWidth;
    	height = bannerHeight;
    	clip = "rect(0 " + bannerWidth + " " + bannerHeight + " 0)";
    	backgroundColor = bannerColor;
    	pixelLeft = bannerLeft;
    	pixelTop = bannerTop;
  	}

  	for (i = 0; i < ar.length; i++) {
    	with (eval("message" + i + ".style")) {
      		visibility = "hidden";
      		pixelLeft = leftPadding;
      		pixelTop = topPadding;
      		width = bannerWidth - leftPadding;
      		backgroundColor = bannerColor;
    	}
  	}
}

function makeNS() {
  	banner = new Layer(bannerWidth);

  	with (banner) {
    	clip.right = bannerWidth;
    	clip.bottom = bannerHeight;
    	document.bgColor = bannerColor;
    	left = bannerLeft;
    	top = bannerTop;
    	visibility = "show";
  	}

  	for (var i = 0; i < ar.length; i++) {
    	eval("message" + i + " = " + 
             "new Layer(bannerWidth - leftPadding, banner)");
    	with(eval("message" + i)) {
      		visibility = "hide";
      		left = leftPadding;
      		top = topPadding;
      		document.bgColor = bannerColor;
    	}
  	}
}

function fillBanner() {
  	var whichEl;
  	if (NS4) {
    	for (var i = 0; i < ar.length; i++) {
      		whichEl = eval("message" + i);
      		whichEl.document.write(ar[i]);
     		whichEl.document.close();
    	}
  	} else {
    	for (var i = 0; i < ar.length; i++) {
      		whichEl = eval("message" + i);
      		whichEl.innerHTML = ar[i];
    	}
  	}
}

function startBanner() {
  	if (NS4){
    	makeNS();
  	}else{
    	makeIE();
	}
  	fillBanner();
  	showMessage(0, true);
  	current = 0;
  	timeoutID = setTimeout("nextMessage()", pause);
}
*/
</Script>
<form name="form2">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name="c_id" value="">
<input type='hidden' name="auth_rw" value="">
</form>
</body>
</html>