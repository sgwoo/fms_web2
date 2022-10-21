<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.off_anc.*, acar.user_mng.*, acar.memo.*, acar.estimate_mng.*, acar.cus_reg.*" %>
<%@ include file="/acar/cookies.jsp" %> 

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
	
	
	//중메뉴
	Vector	 au_menu = umd.getAuthMaMeAll1(acar_id, m_st);
	int aumenu_size = au_menu.size();
	
	
	
	
%>

<html>
<head>
<META HTTP-EQUIV="refresh" CONTENT="3600">
<title>:: FMS(Fleet Management System) ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/sub.css">
<script language='javascript'>
<!--
	function page_link(m_st, m_st2, m_cd, url, auth_rw){	
			
		var fm = document.form1;			
		
		var values 	= '?m_st='+m_st+'&m_st2='+m_st2+'&m_cd='+m_cd+'&url='+url+'&auth_rw='+auth_rw+'&br_id='+fm.br_id.value+'&user_id='+fm.user_id.value;
		
		var menu1 	= fm.m_st.value+''+fm.m_st2.value;
		var menu2 	= m_st+''+m_st2;	
		
		if(menu1 != menu2){			
			location.href 			= 'etc_top.jsp'+values;
		}
		parent.d_menu.location.href = 'emp_menu.jsp'+values;
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
	
	//로그아웃
	function Logout(){
		if(!confirm("로그아웃 하시겠습니까?")){ return; }
		i_no.location ='./del.jsp?login_time=<%=login_time%>&ip=<%=ip%>';
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

</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
        <td width=169 height=49 align=center background=/acar/images/top_bg.gif><a href="http://www.amazoncar.co.kr" target=_blank title='아마존카 홈페이지'><img src=/acar/images/logo.gif width=90 height=23></a></td>
        <td valign=top background=/acar/images/top_bg.gif>
            <table width=100%  border=0 cellspacing=0 cellpadding=0>
                <tr>
                    <td>
                        <table width=100%  border=0 cellspacing=0 cellpadding=0>
                            <tr>
				<td width=400>&nbsp;</td>
                               	<td width=10>&nbsp;</td>
                     	        <td width=48>&nbsp;</td>             
                            
                                <td width=5>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=197>
                        <table width=197 border=0 cellpadding=0 cellspacing=0 >
                            <tr>
                                <td width=4 height=30>&nbsp;&nbsp;&nbsp;</td>
                                <td width=64 align=center>&nbsp;&nbsp;&nbsp;</td>
                                                                 
                                <td width=4>&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td width=8>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan=3>&nbsp;&nbsp;&nbsp;</td>
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
                            <tr>                          
                                <td>&nbsp;&nbsp;&nbsp;</td>
                                
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
                              <td valign=middle><a href="javascript:page_link('01','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image1','','/acar/images/menu_01_1.gif',1)><img src=/acar/images/menu_01.gif name=Image1 border=0></a></td>
                              <td valign=middle><a href="javascript:page_link('02','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image2','','/acar/images/menu_02_1.gif',1)><img src="/acar/images/menu_02.gif" name=Image2 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('03','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image3','','/acar/images/menu_03_1.gif',1)><img src="/acar/images/menu_03.gif" name=Image3 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('04','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image4','','/acar/images/menu_04_1.gif',1)><img src="/acar/images/menu_04.gif" name=Image4 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('05','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image5','','/acar/images/menu_05_1.gif',1)><img src="/acar/images/menu_05.gif" name=Image5 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('06','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image6','','/acar/images/menu_06_1.gif',1)><img src="/acar/images/menu_06.gif" name=Image6 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('07','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image7','','/acar/images/menu_07_1.gif',1)><img src="/acar/images/menu_07.gif" name=Image7 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('08','04','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image8','','/acar/images/menu_08_1.gif',1)><img src="/acar/images/menu_08.gif" name=Image8 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('09','02','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image9','','/acar/images/menu_09_1.gif',1)><img src="/acar/images/menu_09.gif" name=Image9 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('10','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image10','','/acar/images/menu_10_1.gif',1)><img src="/acar/images/menu_10.gif" name=Image10 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('17','04','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image11','','/acar/images/menu_11_1.gif',1)><img src="/acar/images/menu_11.gif" name=Image11 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('11','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image12','','/acar/images/menu_12_1.gif',1)><img src="/acar/images/menu_12.gif" name=Image12 border="0"></a></td>
                              <td valign=middle><a href="javascript:page_link('16','01','','','');" onMouseOut=MM_swapImgRestore() onMouseOver=MM_swapImage('Image13','','/acar/images/menu_13_1.gif',1)><img src="/acar/images/menu_13.gif" name=Image13 border="0"></a></td>
                    		  <td width="20">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                        <!--2 depth menu  권한 시작 -->
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" background="/acar/images/menu_bg_2depth.gif">
                            <tr> 
                                <td width=27 height=28>&nbsp;</td>
                        <%	int t_width = 0;
                        	for (int i = 0 ; i < aumenu_size ; i++){
                        		Hashtable aumenu = (Hashtable)au_menu.elementAt(i);
                        					
                        		String str = aumenu.get("M_NM").toString();
                        		int char_len = str.length();
                        		int byte_len = str.getBytes().length;
                        		int width = byte_len*8;//한글자에8pix=width
                        		t_width += width;
                        %>
                        		<%if(i > 0){%>
                                <td width="1" background="/acar/images/menu_bg_2depth.gif"><img src="/acar/images/menu_2depth_vline.gif"></td>
                            	<%}%>
                            	<%if(m_st2.equals(aumenu.get("M_ST2"))){%>
                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif" height=28><b><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></b></td>
                            	<%}else{%>
                                <td width="<%=width%>" align="center" background="/acar/images/menu_bg_2depth.gif"  height=28><a href="javascript:page_link('<%=aumenu.get("M_ST")%>','<%=aumenu.get("M_ST2")%>','<%//=aumenu.get("M_CD")%>','<%//=aumenu.get("URL")%>','<%//=aumenu.get("AUTH_RW")%>');"><%=aumenu.get("M_NM")%></a></td>
                            	<%}%>
                        <%	}%>
                                <%if((AddUtil.parseInt(s_width)-165-30-t_width) >0){%>
								<td width="<%=(AddUtil.parseInt(s_width)-165-30-t_width)/AddUtil.parseInt(s_width)*100%>" background="../images/sub/sub_top_bg08.gif"></td>
								<%}else{%>
								<td width="1" background="../images/sub/sub_top_bg08.gif"></td>								
								<%}%>
                                <td background="/acar/images/menu_bg_2depth.gif" align="right">&nbsp;</td>
                            </tr>
                        </table>
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

</Script>
<form name="form2">
<input type='hidden' name='m_id' value="">
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name="c_id" value="">
<input type='hidden' name="auth_rw" value="">
</form>
</body>
</html>