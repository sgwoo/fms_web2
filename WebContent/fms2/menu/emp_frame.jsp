<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="java.net.InetAddress"%>
<%@ include file="/acar/cookies.jsp" %> 
<%	
	String url = request.getServerName().toString();
	InetAddress byName = InetAddress.getByName(url);
    /* System.out.println("FMS IP 정보");
    System.out.println("byName.getHostName() : " + byName.getHostName());
    System.out.println("byName.getHostAddress() : " + byName.getHostAddress()); */
    String get_addr = byName.getHostAddress().toString();
    int last_addr_index = get_addr.lastIndexOf(".");
    String last_addr = get_addr.substring(last_addr_index + 1);
    
   // String pass_cng_yn = "Y";
    String pass_cng_yn = "N";
    String end_dt = "99999999";
    
    if(pass_cng_yn.equals("Y")){
	    //비밀번호 재등록처리--------------------------------------------
		LoginBean login = LoginBean.getInstance();
		end_dt = login.getEndDt(ck_acar_id);
    }
%>
<html>
<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
<meta name="viewport" content="width=1245, height=1000,user-scalable=yes, initial-scale=1">
<HEAD>
<TITLE>FMS(<%=last_addr%>)</TITLE>
<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>-->

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<script language=JavaScript>
/*
$(document).keydown(function (e) {
    // F5, ctrl + F5, ctrl + r 새로고침 막기
    var allowPageList   = new Array('/fms2/menu/emp_top.jsp','/fms2/menu/emp_submenu.jsp');
    var bBlockF5Key     = true;
    for (number in allowPageList) {
        var regExp = new RegExp('^' + allowPageList[number] + '.*', 'i');
        if (regExp.test(document.location.pathname)) {
            bBlockF5Key = false;
            break;
        }
    }
     
    if (bBlockF5Key) {
        if (e.which === 116) {
            if (typeof event == "object") {
                event.keyCode = 0;
            }
            return false;
        } else if (e.which === 82 && e.ctrlKey) {
            return false;
        }
    }
});	
*/
</script>
	<script>
$(window).bind("orientationchange", function(){

	   var orientation = window.orientation;

var new_orientation = (orientation) ? 0 : 90 + orientation;

		$('body').css({

		"-webkit-transform": "rotate(" + new_orientation + "deg)"     

	});

});


function enddt_reset(){
	window.open("/fms2/menu/pass_u.jsp", "PASS", "left=10, top=10, width=400, height=200, scrollbars=yes, status=yes, resizable=yes");
}

</script>

</HEAD>
<%if(AddUtil.parseInt(end_dt) < AddUtil.parseInt(AddUtil.getDate(4))){%>
	<script>
	enddt_reset();
</script>	
<%}else{%>
<FRAMESET ROWS="90,0,*" border=0>
	<FRAME NAME="top_menu"  SRC="/fms2/menu/emp_top.jsp" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>
	<FRAME NAME="sub_menu"  SRC="/fms2/menu/emp_submenu.jsp" frameborder=0 marginwidth=0 marginheight=0 scrolling="auto" noresize>
	<FRAMESET COLS="0,*" border=0>
		<FRAME name="mymenu_fix" SRC="/fms2/menu/emp_mymenu_fix.jsp" frameborder=0 marginwidth=0 marginheight=0 scrolling="no" noresize>		
		<FRAME name="d_content" SRC="/fms2/menu/emp_content.jsp" frameborder=0 marginwidth=10 marginheight=10 scrolling="auto" noresize>		
	</FRAMESET> 	
</FRAMESET>	
<NOFRAMES>
<BODY>
<P>이 페이지를 보려면, 프레임을 볼 수 있는 브라우저가 필요합니다.</P>
</body>
</NOFRAMES>
<%}%>
</HTML>