<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<script>
var cookie_name = "tmp_waste";
window.onbeforeprint = function(){
	var isCookie = getCookie(cookie_name);
	
	if( isCookie == null || isCookie.length <= 0 ){
		setCookie(cookie_name, 'delete', 1);
	}  
	
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// 쿠키 가져오기
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie(cookie_name, 'delete', 1);

//차량사진 출력
function file_down(){
	
	var fm = document.form1;
	var SUMWIN = "";	
	var down_name=encodeURIComponent(fm.filename.value);	  			
	window.open(SUMWIN, "downfile", "left=50, top=50, width=1050, height=800, scrollbars=yes, status=yes");		
		
	fm.target = "downfile";
	fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/filezip_multi.jsp?DOWNFILENAME="+down_name;
	fm.submit();		
	
}



</script>
</head>

<body leftmargin="15" topmargin="1" onUnload="javascript:setCookie('tmp_waste', '', -1);" >

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
		
	String car_ext 	= request.getParameter("car_ext5")==null?"":request.getParameter("car_ext5");  //지점
	int car_cnt 	= request.getParameter("car_cnt5")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt5"));
	String st_dt 		= request.getParameter("st_dt")		==null?"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String s_dt	 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String car_use	 	= request.getParameter("car_use5")	==null?"":request.getParameter("car_use5");
	String car_fuel 	= request.getParameter("car_fuel")	==null?"":request.getParameter("car_fuel");
		
	Vector vt = ad_db.getCarExtCngExcelList5(car_ext, car_use, st_dt, end_dt, s_dt, car_fuel);
	int vt_size = vt.size();
			
	String filename = car_ext+"_"+AddUtil.getDate(4);
		
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	double img_width 	= 680;
	double img_height 	= 1009;
			
	String vid_num 	= "";
	
	String seq = "";
	
%>

<form action="" name="form1" method="POST" >
<input type="button" class="button" id='downfile' value='저장' onclick="javascript:file_down()">	  
<p style='page-break-before:always'><br style="height:0; line-height:0"></P>
<% for(int ii=0;ii < vt_size; ii++){
		
		Hashtable ht = (Hashtable)vt.elementAt(ii);
		
		vid_num = String.valueOf(ht.get("CAR_MNG_ID")); //				 
%>

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
<%
				
			Vector fs = FineDocDb.getBank_scanreg(vid_num);
			int fs_size = fs.size();
			if(fs_size>0){
				for(int i = 0 ; i < fs_size ; i++){
					Hashtable htt = (Hashtable)fs.elementAt(i); 
					
					int size = 0;
		
					String content_code = "CAR_CHANGE";
					String content_seq  = (String)htt.get("CAR_MNG_ID")+(String)htt.get("CHA_SEQ");
		
					Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
					int attach_vt_size = attach_vt.size();
		
					for(int j=0; j< attach_vt.size(); j++){
						Hashtable aht = (Hashtable)attach_vt.elementAt(j); 
						
%>
		<tr>
			<td>
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=aht.get("SEQ")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
			</td>
		</tr>
		<input type="hidden" name="SEQ" value="<%=vid_num%>">

<%				    }
			  }
		}	

}  //vt_size  end
%>
</table>
<input type="hidden" name="filename" value="<%=filename%>">
<input type="hidden" name="CONTENT_CODE" value="CAR_CHANGE">

<!-- <input type="button" class="button" id='downfile' value='저장' onclick="javascript:file_down()">	    -->	  

</form>
</body>
</html>

<script>
onprint();

function onprint(){
	var userAgent = navigator.userAgent.toLowerCase();
	if (userAgent.indexOf("edge") > -1) {
		window.print();
	} else if (userAgent.indexOf("whale") > -1) {
		window.print();
	} else if (userAgent.indexOf("chrome") > -1) {
		window.print();
	} else if (userAgent.indexOf("firefox") > -1) {
		window.print();
	} else if (userAgent.indexOf("safari") > -1) {
		window.print();
	} else {
		IE_Print();
	}
}	

function IE_Print() {
factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
//-->

</script>
