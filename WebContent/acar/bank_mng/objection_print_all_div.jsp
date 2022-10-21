<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*, acar.estimate_mng.*, acar.cont.*,acar.car_register.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
	
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>

<style>

@page a4sheet { size: 21.0cm 29.7cm }

</style>

<script>

window.onbeforeprint = function(){
	//setCookie();
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

setCookie('tmp_waste', 'delete', 1);

</script>
</head>
<body leftmargin="15" topmargin="1">
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
	
	
	String doc_id 	= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	int start_num 	= request.getParameter("start_num")==null?0:AddUtil.parseInt(request.getParameter("start_num"));
	int end_num 	= request.getParameter("end_num")==null?0:AddUtil.parseInt(request.getParameter("end_num"));
	String chk 	= request.getParameter("chk")==null?"":request.getParameter("chk");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();

		
	double img_width 	= 680;
	double img_height 	= 1009;


	//리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	String c_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
	String m_id[] = new String[FineList.size()];
	
	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);
			
			c_id[i] = String.valueOf(ht.get("CAR_MNG_ID"));
			m_id[i] = String.valueOf(ht.get("RENT_MNG_ID"));	
			l_cd[i] = String.valueOf(ht.get("RENT_L_CD"));	

	 	}
	} 
%>

<form action="" name="form1" method="POST" >

<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" align=center>

<%		for(int k=start_num-1; k<end_num; k++){ 

			String car_mng_id = c_id[k];
			String rent_mng_id = m_id[k];
			String rent_l_cd = l_cd[k];
			String rent_st = "1";
			
			int size = 0;
			
			String content_code = "";
			String content_seq  = "";
			
			String file_type1 = "";
			String seq1 = "";
			String file_name1 = "";
			
			String file_type2 = "";
			String seq2 = "";
			String file_name2 = "";
			
			String file_type3 = "";
			String seq3 = "";
			String file_name3 = "";
			
			String file_type4 = "";
			String seq4 = "";
			String file_name4 = "";
				
			String file_type5 = "";
			String seq5 = "";
			String file_name5 = "";				
			
			if(chk.equals("3")){
			
				Vector fs = FineDocDb.getBank_scan(car_mng_id, rent_l_cd, chk);
				int fs_size = fs.size();
				
					for(int i = 0 ; i < fs_size ; i++){
						Hashtable ht = (Hashtable)fs.elementAt(i); 
					
						content_code = "CAR_CHANGE";
						content_seq  = (String)ht.get("CAR_MNG_ID")+(String)ht.get("CHA_SEQ");
				
					
						Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
						int attach_vt_size = attach_vt.size();
	
						for(int j=0; j< attach_vt.size(); j++){
							Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
						
							if((content_seq).equals(aht.get("CONTENT_SEQ"))){
								file_name4 = String.valueOf(aht.get("FILE_NAME"));
								file_type4 = String.valueOf(aht.get("FILE_TYPE"));
								seq4 = String.valueOf(aht.get("SEQ"));
							}
						}	
					
				
					
%>
	
	<tr valign="top">
		<td>
	<%if(chk.equals("3")) {%>	
			<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq4%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
	<%}%>
		</td>
	</tr>
<%}
}else if(!chk.equals("3")){
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+rent_l_cd+rent_st;
//System.out.println("content_seq="+content_seq);	
	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();

	for(int j=0; j< attach_vt.size(); j++){
	Hashtable aht = (Hashtable)attach_vt.elementAt(j);   

		if((content_seq+17).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
			
		}else if((content_seq+18).equals(aht.get("CONTENT_SEQ"))){
			file_name2 = String.valueOf(aht.get("FILE_NAME"));
			file_type2 = String.valueOf(aht.get("FILE_TYPE"));
			seq2 = String.valueOf(aht.get("SEQ"));
		
		}else if((content_seq+10).equals(aht.get("CONTENT_SEQ"))){
			file_name3 = String.valueOf(aht.get("FILE_NAME"));
			file_type3 = String.valueOf(aht.get("FILE_TYPE"));
			seq3 = String.valueOf(aht.get("SEQ"));
		
		}else if((content_seq+15).equals(aht.get("CONTENT_SEQ"))){
			file_name5 = String.valueOf(aht.get("FILE_NAME"));
			file_type5 = String.valueOf(aht.get("FILE_TYPE"));
			seq5 = String.valueOf(aht.get("SEQ"));	
			
		}
	}
%>

<% if (chk.equals("2")) { %>
		<tr valign="top">
			<td>
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq3%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
			</td>
		</tr>	
<% } else if (chk.equals("4")) { %>
		<tr valign="top">
			<td>
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq5%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
			</td>
		</tr>					
<% } else if(chk.equals("1")) {%>
   <% if ( !seq1.equals("") ) { %> 
		<tr valign="top">
			<td>
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq1%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=seq2%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
		    </td>
		</tr>	
	<% } %> 	
<%}%>
	
<%}

}%>
</table>	


</form>
</body>
</html>
<script>
onprint();

//5초후에 인쇄박스 팝업
//setTimeout(onprint_box,5000);


function onprint(){
	factory.printing.header 	= ""; //폐이지상단 인쇄
	factory.printing.footer 	= ""; //폐이지하단 인쇄
	factory.printing.portrait 	= true; //true-세로인쇄, false-가로인쇄    
	factory.printing.leftMargin 	= 10.0; //좌측여백   
	factory.printing.rightMargin 	= 10.0; //우측여백
	factory.printing.topMargin 	= 10.0; //상단여백    
	factory.printing.bottomMargin 	= 10.0; //하단여백
}
function onprint_box(){
	factory.printing.Print(true, window);//arg1-대화상자표시여부(true or false), arg2-전체윈도우or특정프레임
}
</script>
