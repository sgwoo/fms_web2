<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.car_register.*,acar.common.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp"%>

<%
	//자동차번호변경 이력 리스트 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "02", "01");
	
	String st 		= request.getParameter("st")==null?"":request.getParameter("st");
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm 	= request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String q_sort_nm 	= request.getParameter("q_sort_nm")==null?"":request.getParameter("q_sort_nm");
	String q_sort 		= request.getParameter("q_sort")==null?"":request.getParameter("q_sort");
	String ref_dt1 		= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 		= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(car_mng_id);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		theURL = "https://fms3.amazoncar.co.kr/data/carReg/"+theURL+""+file_type;
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj = window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();
	}	
	
	//스캔한 등록증 보기
	function view_scanfile(idx){
		var  path = "";
		<% if(ch_r.length > 1){ %>
			path = document.form1.scanfile[idx].value;
		<% }else{ %>
			path = document.form1.scanfile.value;
		<% } %>
			
		var size = 'width=700, height=650, scrollbars=yes';
		window.open("https://fms3.amazoncar.co.kr/data/carReg/"+path+".pdf", "SCAN", "left=50, top=30,"+size+", resizable=yes");
	}	
	
	//삭제하기
	function del_scanfile(idx, cha_seq){
		var fm = document.form1;
		var path = "";
		var file_type = "";
		
		if(idx>0)	path 		= fm.scanfile[idx].value;
		else		path 		= fm.scanfile.value;
		
		if(idx>0)	file_type 	= fm.file_type[idx].value;
		else		file_type 	= fm.file_type.value;
		
		if(!confirm("해당내용을 삭제하시겠습니까?"))	return;		
		fm.scanfile_nm.value 	= path;		
		fm.scanfile_type.value 	= file_type;		
		fm.cha_seq.value = cha_seq;		
		fm.target = "i_no";
//		fm.action = "/register_his_id_del.jsp";
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/car_register_register_his_id_del.jsp";
		fm.submit();
	}	
		
	//스캔등록
	function scan_reg(car_mng_id, cha_seq, cha_car_no){
		window.open("reg_scan.jsp?car_mng_id="+car_mng_id+"&cha_seq="+cha_seq+"&subject="+cha_car_no, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}

		
	//등록하기
	function Reg(){
		fm = document.form1;
		if(fm.car_mng_id.value==''){	alert("상단을 먼저 등록해주세요!"); return; }
		fm.target = "c_foot";
		fm.action = "./register_his_id_ins.jsp";
		fm.submit();
	}

	//수정하기
	function upd_car(idx){
		var fm = document.form1;
		fm.cha_seq.value = idx;
		fm.target = "c_foot";
		fm.action = "./register_his_id_upd.jsp";
		fm.submit();		
	}
	
	//삭제하기 (자동차 번호 이력 자체를 삭제. 단,등록된 스캔이 없어야 버튼 노출됨. 2018.01.17)
	function del_car(idx){
		if(confirm("정말 삭제 하시겠습니까?")){
			var fm = document.form1;
			fm.cha_seq.value = idx;
			fm.target = "c_foot";
			fm.action = "./register_his_id_del2.jsp";
			fm.submit();		
		}
	}
//-->	
</script>
</head>

<body>
<form name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="rent_mng_id" value="<%=rent_mng_id%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">
<input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
<input type="hidden" name="cmd" value="<%=cmd%>">
<input type="hidden" name="st" value="<%=st%>">
<input type="hidden" name="gubun" value="<%=gubun%>">
<input type="hidden" name="gubun_nm" value="<%=gubun_nm%>">
<input type="hidden" name="q_sort_nm" value="<%=q_sort_nm%>">
<input type="hidden" name="q_sort" value="<%=q_sort%>">
<input type="hidden" name="ref_dt1" value="<%=ref_dt1%>">
<input type="hidden" name="ref_dt2" value="<%=ref_dt2%>">
<input type="hidden" name="cha_seq" value="">
<input type="hidden" name="scanfile_nm" value="">
<input type="hidden" name="scanfile_type" value="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차번호이력</span></td>
        <td><div align="right">
    	<%//if(br_id.equals("S1") || br_id.equals(brch_id)){%> 
    	<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    	<a href="javascript:Reg();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
    	<%	}%>
    	<%//}%>
    	</div>
    	</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class="line" colspan=2>
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class=title width=7%>연번</td>
                    <td class=title width=12%>변경일자</td>
                    <td class=title width=15%>차량번호</td>
                    <td class=title width=15%>사유</td>
                    <td class=title width=27%>상세내용</td>
                    <td class=title width=17%>등록증스캔</td>
                    <td class=title width=7%></td>
                </tr>
                <%if(ch_r.length > 0){
        		for(int i=0; i<ch_r.length; i++){
        			ch_bean = ch_r[i];	
        			
				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				String content_code = "CAR_CHANGE";
				String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				int attach_vt_size = attach_vt.size();	
        			
        	%>
                <tr> 
                    <td align="center"><%=ch_bean.getCha_seq()%></td>
                    <td align="center"><%=ch_bean.getCha_dt()%></td>
                    <td align="center"><%=ch_bean.getCha_car_no()%></td>
                    <td align="center"> 
                        <% if(ch_bean.getCha_cau().equals("1")){%>
                            사용본거지 변경 
                        <%}else if(ch_bean.getCha_cau().equals("2")){%>
                            용도변경 
                        <%}else if(ch_bean.getCha_cau().equals("3")){%>
                            기타 
                        <%}else if(ch_bean.getCha_cau().equals("4")){%>
                            없음 
                        <%}else if(ch_bean.getCha_cau().equals("5")){%>
                            신규등록 
                        <%}%>
                    </td>
                    <td>&nbsp;<%=ch_bean.getCha_cau_sub()%></td>
                    <td align=center> 
                                                <%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);    								
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
    							&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=attach_ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>    						
    						<%	}%>		
    						<%}else{%>
    						<%-- <a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a> --%>
    						<a href="javascript:scan_reg('<%=ch_bean.getCar_mng_id()%>','<%=ch_bean.getCha_seq()%>','<%=ch_bean.getCha_car_no()%>')"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>
    						<%}%>        		        		
                    </td>
                    <td align=center>                     
        		<%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        		<a href="javascript:upd_car('<%=ch_bean.getCha_seq()%>');"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a>
        			<!-- 자동차번호이력 삭제버튼 추가(스캔이 등록되어 있으면 스캔삭제 먼저해야 노출되게 처리) (2018.01.17) -->
        			<%if(attach_vt_size == 0 && ch_bean.getCha_cau().equals("3") && ch_bean.getCha_cau_sub().contains("차령")){ %>
        				<a href="javascript:del_car('<%=ch_bean.getCha_seq()%>');"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        			<%} %>	
        		<%}%>
                    </td>
                </tr>
                <%	}
        	}else{%>
                <tr> 
                    <td colspan="7"><div align="center">등록된 데이타가 없습니다.</div></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</html>

