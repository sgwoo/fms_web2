<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>

</head>
<body leftmargin="15" topmargin="1"  >
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
	
	String vid_c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String vid_m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String vid_l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String vid_ct_id = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	
		
	String vid[] = request.getParameterValues("ch_l_cd");
	String list_size = "";
	String vid_num="";
	String img_url = "";
	
	double img_width 	= 680;
	double img_height 	= 1009;

	int vid_size = vid.length;
	int action_size = vid_size;
	


for(int j=0;j < vid_size;j++){
		//
		vid_num 	= vid[j];
//System.out.println(vid_num);				
		vid_c_id 		= vid_num.substring(0,6);
		vid_m_id		= vid_num.substring(6,12);
		vid_l_cd		= vid_num.substring(12,24);
		vid_ct_id		= vid_num.substring(vid_num.length()-6, vid_num.length());
//System.out.println(vid_c_id);				
//System.out.println(vid_m_id);				
//System.out.println(vid_l_cd);				
//System.out.println(vid_ct_id);						
		
		list_size 	= vid_num.substring(12);

		action_size = action_size + Util.parseInt(list_size);
		
	
%>


<form action="" name="form1" method="POST" >
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4" align=center>
<%


String rent_mng_id = vid_m_id;
String rent_l_cd = vid_l_cd;
String client_id = vid_ct_id;
Vector fs = FineDocDb.getFind_scan(rent_mng_id, rent_l_cd, client_id);
int fs_size = fs.size();
if(fs_size>0){
	for(int i = 0 ; i < fs_size ; i++){
		Hashtable ht = (Hashtable)fs.elementAt(i); 
			if(ht.get("FILE_TYPE").equals(".jpg")){
%>
	<tr>
		<td height=1039>
			<img src="https://fms3.amazoncar.co.kr/data/<%= AddUtil.replace(AddUtil.replace(AddUtil.replace(String.valueOf(ht.get("FILE_PATH")),"D:\\Inetpub\\wwwroot\\data\\",""),"D:\\Inetpub\\wwwroot\\data\\",""),"\\","/") %><%=ht.get("FILE_NAME")%>.jpg" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">

		</td>
	</tr>
<%}
	}
	}
%>
</table>

</form>

</body>
<%}%>
</html>

<script>
onprint();

function onprint(){


factory.printing.header = ""; //폐이지상단 인쇄
factory.printing.footer = ""; //폐이지하단 인쇄
factory.printing.portrait = true; //true-세로인쇄, false-가로인쇄    
factory.printing.leftMargin = 10.0; //좌측여백   
factory.printing.topMargin = 10.0; //상단여백    
factory.printing.rightMargin = 10.0; //우측여백
factory.printing.bottomMargin = 10.0; //하단여백
factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
