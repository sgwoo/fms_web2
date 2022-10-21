<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
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

</script>
</head>

<body leftmargin="15" topmargin="1" onUnload="javascript:setCookie('tmp_waste', '', -1);" >

<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 

	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	double img_width 	= 680;
	double img_height 	= 1009;

	//과태료리스트
//	Vector FineList = FineDocDb.getFineDocLists(doc_id);
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	String c_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
			
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);
			
			c_id[i] = String.valueOf(ht.get("CAR_MNG_ID"));
			l_cd[i] = String.valueOf(ht.get("RENT_L_CD"));	
	 	}
	} 

%>

<form action="" name="form1" method="POST" >

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>
<%

for(int k=0; k<FineList.size(); k++){ 
	String car_mng_id = c_id[k];
	String rent_l_cd = l_cd[k];
	
	
	Vector fs = FineDocDb.getBank_scanreg(car_mng_id);
	int fs_size = fs.size();
	if(fs_size>0){
		for(int i = 0 ; i < fs_size ; i++){
			Hashtable ht = (Hashtable)fs.elementAt(i); 
			
			int size = 0;

			String content_code = "CAR_CHANGE";
			String content_seq  = (String)ht.get("CAR_MNG_ID")+(String)ht.get("CHA_SEQ");

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
<%}
	}
	}
}%>
</table>
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
