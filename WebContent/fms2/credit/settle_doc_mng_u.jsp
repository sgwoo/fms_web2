<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*,  acar.client.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
	
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	String email = "";
		
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	email = FineDocBn.getRemarks();
	
	//미수채권 리스트
	Vector FineList = FineDocDb.getSettleDocLists(doc_id);
	
	//거래처
	ClientBean client = al_db.getClient(gov_id);
	
	if ( email.equals("") ) {
	
		email = client.getCon_agnt_email();
	
	}
	
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//수정하기
	
	function fine_update(){
		var fm = document.form1;
		var fm2 = document.form2;
		fm2.doc_dt.value = fm.doc_dt.value;
		fm2.gov_addr.value = fm.gov_addr.value;
		fm2.mng_dept.value = fm.mng_dept.value; 
		fm2.title.value = fm.title.value; 
		fm2.end_dt.value = fm.end_dt.value; 
		fm2.f_result.value = fm.f_result.value; 
		fm2.f_reason.value = fm.f_reason.value; 
		fm2.email.value = fm.email.value; 
		if(!fm.filename2.value==''){
				file_save();
		}
		
		fm2.target = "i_no";
		fm2.action = "settle_doc_mng_u_a.jsp";	
		fm2.submit();
	}	
	function file_delete(seq1){
		var fm = document.form1;	
		fm.target = "_blank";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq1;
		fm.submit();
		
}
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	function file_save(){
		var fm = document.form1;	
				
		if(!confirm('파일등록하시겠습니까?')){
			return;
		}
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.FINE_DOC%>";
		fm.submit();
	}
				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='s_end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='doc_id' value='<%=doc_id%>'>
<input type='hidden' name='gov_nm' value='<%=FineDocBn.getGov_nm()%>'>
<input type='hidden' name='gov_id' value='<%=gov_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5>최고장관리 수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td align="right">
      <a href="javascript:fine_update();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
	  <a href="javascript:window.close();" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
      </tr>
      <tr>
        <td class=line2></td>
     </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width=12%>문서번호</td>
            <td colspan=3>&nbsp;<%=FineDocBn.getDoc_id()%></td>
          </tr>
          <tr> 
            <td class='title'>시행일자</td>
            <td colspan=3>&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getDoc_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
          <tr> 
            <td rowspan="2" class='title'>수신</td>
            <td colspan=3> &nbsp;<%=FineDocBn.getGov_nm()%></td>
          </tr>
          <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('gov_zip').value = data.zonecode;
								document.getElementById('gov_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
							
          <tr>
            <td colspan=4> &nbsp;<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
            &nbsp;<input type="text" name="gov_zip" id="gov_zip" size="10" class="text" value="<%=FineDocBn.getGov_zip()%>">&nbsp;<input type="text" name="gov_addr" id="gov_addr" size="100" class="text" value="<%=FineDocBn.getGov_addr()%>">&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>참조</td>
            <td colspan=3 >&nbsp;<input type="text" name="mng_dept" size="50" class="text" value="<%=FineDocBn.getMng_dept()%>">
			</td>
          </tr>
          <tr> 
            <td class='title'>제목</td>
            <td colspan=3>&nbsp;<input type="text" name="title" size="100" class="text" value="<%=FineDocBn.getTitle()%>">
			<!--
			  <select name='title'>
                  <option value='' <%if(FineDocBn.getTitle().equals(""))%>selected<%%>>선택</option>
                  <option value="최고장"               				<%if(FineDocBn.getTitle().equals("최고장"))%>selected<%%>							>최고장</option>				  
                  <option value="납입최고 및 해지예고" 				<%if(FineDocBn.getTitle().equals("납입최고 및 해지예고"))%>selected<%%>				>납입최고 및 해지예고</option>				  
				  <option value="해지예고통보" 						<%if(FineDocBn.getTitle().equals("해지예고통보"))%>selected<%%>						>해지예고통보</option>				  
				  <option value="해지통보" 							<%if(FineDocBn.getTitle().equals("해지통보"))%>selected<%%>							>해지통보</option>				  
                  <option value="해지통보 및 해지정산금 납입고지" 	<%if(FineDocBn.getTitle().equals("해지통보 및 해지정산금 납입고지"))%>selected<%%>	>해지통보 및 해지정산금 납입고지</option>
                  <option value="계약해지 및 차량반납 통보" 		<%if(FineDocBn.getTitle().equals("계약해지 및 차량반납 통보"))%>selected<%%>		>계약해지 및 차량반납 통보</option>
                  <option value="기타" 								<%if(FineDocBn.getTitle().equals("기타"))%>selected<%%>								>기타</option>				  				  
               </select>
			   --></td>
          </tr>          
          <tr> 
            <td class='title'>유예기간</td>
            <td colspan=3>&nbsp;<input type="text" name="end_dt" size="11" class="text" value="<%=AddUtil.ChangeDate2(FineDocBn.getEnd_dt())%>" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>		
          <tr> 
            <td class='title'>스캔</td>
            <td colspan=3>
            
            <% if(FineDocBn.getFilename().equals("")){
            String content_code = "FINE_DOC";
									String content_seq  = FineDocBn.getDoc_id()+"";
								
									Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
									int attach_vt_size = attach_vt.size();
									
									for(int k=0; k< attach_vt.size(); k++){
										Hashtable aht = (Hashtable)attach_vt.elementAt(k);   
										
											if((content_seq).equals(aht.get("CONTENT_SEQ"))){
												file_name1 = String.valueOf(aht.get("FILE_NAME"));
												file_type1 = String.valueOf(aht.get("FILE_TYPE"));
												seq1 = String.valueOf(aht.get("SEQ"));
										
											}
									}
									if(!file_name1.equals("")){
            %>
            					<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
														<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><%=file_name1%></a>
											<%}else{%>
														<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=FineDocBn.getFilename()%>" target='_blank'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
											<%}%>
														 &nbsp;<a href="javascript:file_delete('<%=FineDocBn.getDoc_id()%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
            <%		}
            }else{%>
            &nbsp;<a href="https://fms3.amazoncar.co.kr/data/stop_doc/<%=FineDocBn.getFilename()%>" target="_blank"><%=FineDocBn.getFilename()%></a>
            <%}%>
			<br><input type="file" name="filename2" size="40">
			<input type='hidden' name="<%=Webconst.Common.contentSeqName %>" size='' class='text' value='<%=doc_id%>' />
					<input type="hidden" name="<%=Webconst.Common.contentCodeName %>" value='<%=UploadInfoEnum.FINE_DOC%>' /></td>
          </tr>
          <tr> 
            <td class='title'>안내메일</td>
            <td  colspan=3>&nbsp;메일주소 : <input type='text' name='email' size='30' value='<%=email%>' class='text'>&nbsp;
           
            </td>
          </tr>	  
          	
          <tr>
           <td class='title'>결과</td>
           <td>&nbsp; 
			  <select name="f_result" >
			    <option value="" <% if(FineDocBn.getF_result().equals("")){%>selected<%}%>>--선택--</option>
                <option value="1" <% if(FineDocBn.getF_result().equals("1")){%>selected<%}%>>반송</option>
				<option value="2" <% if(FineDocBn.getF_result().equals("2")){%>selected<%}%>>도착</option>
              
              </select>
		    </td>
		    <td class='title'>사유</td>
            <td>&nbsp; 
			  <select name="f_reason" >
			    <option value="" <% if(FineDocBn.getF_reason().equals("")){%>selected<%}%>>--선택--</option>
                <option value="1" <% if(FineDocBn.getF_reason().equals("1")){%>selected<%}%>>이사감</option>
                <option value="2" <% if(FineDocBn.getF_reason().equals("2")){%>selected<%}%>>수취인부재</option>
                <option value="3" <% if(FineDocBn.getF_reason().equals("3")){%>selected<%}%>>폐문부재</option>
                <option value="4" <% if(FineDocBn.getF_reason().equals("4")){%>selected<%}%>>수취거절</option>
                <option value="5" <% if(FineDocBn.getF_reason().equals("5")){%>selected<%}%>>주소불명</option>
                <option value="6" <% if(FineDocBn.getF_reason().equals("6")){%>selected<%}%>>수취인불명</option>              
              
              </select>
		    </td>
         
          </tr>	  		  
		    		  
        </table>
      </td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<form action="" name="form2" method="POST">
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='user_id' value='<%=user_id%>'>
	<input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='s_end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type='hidden' name='doc_id' value='<%=doc_id%>'>
	<input type='hidden' name='doc_dt' value=''>
	<input type='hidden' name='gov_addr' value=''>
	<input type='hidden' name='mng_dept' value=''>
	<input type='hidden' name='title' value=''>
	<input type='hidden' name='end_dt' value=''>
	<input type='hidden' name='f_result' value=''>
	<input type='hidden' name='f_reason' value=''>
	<input type='hidden' name='email' value=''>
	<input type='hidden' name='gov_nm' value='<%=FineDocBn.getGov_nm()%>'>
	<input type='hidden' name='gov_id' value='<%=gov_id%>'>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
