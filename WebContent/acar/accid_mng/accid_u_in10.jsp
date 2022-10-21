<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String mode = request.getParameter("mode")==null?"10":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "01", "02");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	
	int s_idx=0;
	int e_idx=0;
	int size = 0;
	
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	
	String content_code = "PIC_ACCID";
	String content_seq  = c_id+""+accid_id;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String agent = request.getHeader("User-Agent");

	String browser ="";
	if (agent.indexOf("Trident") > 0 || agent.indexOf("MSIE") > 0) {
		 browser = "IE";
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	var popObj = null;

	//사진올리기
	function CarImgAdd(){
		var fm = document.form1;
		var SUBWIN="./car_img_adds.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>";	
		window.open(SUBWIN, "CarImgAdd", "left=250, top=250, width=600, height=430, resizable=yes, scrollbars=yes, status=yes");
	}	

	//새로고침
	function reload_page(){
		var fm = document.form1;
		fm.target = '_self';
		fm.action = 'accid_u_in10.jsp';
		fm.submit();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	$(document).ready(function() {
	
		$('#upload-select-fake').bind('click', function() {
			//removefile();
			$('#upload-select').trigger('click');
		});
	
		
		$('#upload-select').change(function() {
			 var list = '';
	         fileIdx = 0;
	         for (var i = 0; i < this.files.length; i++) {
	             fileIdx += 1;
	             list += fileIdx + '. ' + this.files[i].name + '\n';
	         }
	         //파일리스트
	       //  $('#upload-list pre').append(list);
	         
	         for (var i = 0; i < this.files.length; i++) {
		         var file = this.files[i];
		         var tokens = file.name.split('.');
		         tokens.pop();
		         var content_seq = '<%=c_id%><%=accid_id%>';
		         var file_name = this.files[i].name;
		     	 var file_size = this.files[i].size;
		         var file_type = this.files[i].type;
		         
		         var tr =
		             '<tr><td>' +
		             '' +
		             '<input type="hidden" name="content_seq" value="'+ content_seq +'">' +
		             '<input type="hidden" name="file_name" value="'+ file_name +'">' +
		             '<input type="hidden" name="file_size" value="'+ file_size +'">' +
		             '<input type="hidden" name="file_type" value="'+ file_type +'">' +
		             '</td></tr>';
		         //파일 정보    
		         $('#file-upload-form').append(tr);
	         }
	         
		     	var real= $('#upload-select');
		    	var cloned = real.clone(true);
		    	real.hide();
		    	cloned.insertAfter(real);
		    	real.appendTo('#form2');
		    	
		    	
		        if(!confirm("해당 파일을 등록하시겠습니까?")) return;
			       var refresh=false;
			       if(validation()){
			         $("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=PIC_ACCID");//실제사용
			        //  $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=PIC_ACCID"); //테스트용
			          $("#form2").attr("target","_blank");
			          $("#form2").submit();
			          refresh=true;	
			       }
			       if(refresh){
			    	   setTimeout(function() {
							location.reload();// 프레임새로고침
						}, 2000);
					}
			});
		
		//validation
		function validation(){
			var check = false;
			if($('#file-upload-form').find('tr').html() == undefined){
				alert("파일을 등록해주세요");
			}else{
				 check = true;
			}  
			return check;
		}
		
        
	});
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='accid_id' value='<%=accid_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='cmd' value='<%=cmd%>'>
<input type='hidden' name='go_url' value='<%=go_url%>'>  		
<input type='hidden' name='seq' value=''>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고차량 사진</span></td>
        <td align="right">
        	<%if(!mode.equals("view")){%>
	          <%	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	          <%if(browser.equals("IE")){%>
	           	 <a href="javascript:CarImgAdd()"><img src="/acar/images/center/button_reg_p.gif" align="absmiddle" border="0"></a> 
	          <%}else{ %>
	           	<img src="/acar/images/center/button_reg_p.gif" align="absmiddle" border="0" id="upload-select-fake" style="cursor:pointer"> 
			    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
	          <%} %>
	          <%}else{%>권한이 없습니다.<%}%>
	          &nbsp;&nbsp;<span class="b"><a href="javascript:reload_page()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a></span>
	         <%if(!browser.equals("IE")){%>
		          &nbsp;&nbsp;<span class="b"><a href="javascript:CarImgAdd()">기존방식 사진등록</a> </span>
	         <%} %>
	        <%}else{%>
	          <a href='javascript:window.close()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a>
	        <%}%>
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>    
	
    <!--ACAR_ATTACH_FILE-->
    <%if(attach_vt_size > 0){
		size = attach_vt_size;
		s_idx = 0;
		e_idx = 0;
    %>		
    <tr> 
        <td class=line colspan="2"> 
            <table border=0 cellspacing=1 width=100%>
		<%for(int k=0; k<size; k++){
			s_idx = 6*k;			//0, 6,12,18...
			e_idx = 6*(k+1);		//6,12,18,24...%>
			
                <%	if(size > s_idx){%>			
                <tr valign="top"> 
                    <%		for(int i=s_idx; i<size && i<e_idx; i++){
                			Hashtable ht = (Hashtable)attach_vt.elementAt(i);                		
                    %>
                    <td align="center" width=16% style='height:140'>
                        <a class=index1 href="javascript:MM_openBrWindow('attach_big_imgs2.jsp?content_code=<%=content_code%>&content_seq=<%=content_seq%>&seq=<%=ht.get("SEQ")%>','popwin0','scrollbars=yes,status=yes,resizable=yes,width=700,height=658,left=50, top=50')"> 
                            <img name="carImg" src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" border="0" width="130" height="98">
                        </a>
                        <br><br>
			<%=i+1%>번 
			<a href="javascript:openPopF('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='차량사진 크게 보기' ><img src="/acar/images/large.gif" border="0"></a>
			&nbsp;&nbsp;
			      <%if(!mode.equals("view")){%>
        		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                            <a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        		<%}%>
        		<%}%>
        	    </td>
                    <%		}%>
                    <%		for(int i=size; i<e_idx; i++){%>
                    <td align="center" width=16% style='height:140'><img name="carImg" src="http://fms1.amazoncar.co.kr/images/no_photo.gif" border="0" width="130" height="98"></td>
                    <%		}%>
                </tr>
                <%	}%>				
		<%}%>
            </table>
        </td>
    </tr>
    <%}%>
  </form>	
</table>

<!--파일업로드 정보  -->
<form name="form2" id="form2" action="" method="post" enctype="multipart/form-data">
	<div>
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>

</body>
</html>
