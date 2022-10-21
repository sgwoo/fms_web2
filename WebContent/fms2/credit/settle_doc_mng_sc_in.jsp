<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	String gubun_nm = "";
	
	
	if ( gubun1.equals("2") ) {
			gubun_nm = "법무";
	}else if(gubun1.equals("3")){
			gubun_nm = "고소";
	} else{
			gubun_nm = "채권추심";
	}		
	
	Vector fines = FineDocDb.getFineDocLists(gubun_nm, br_id, "", gubun2, gubun3, gubun4, "", st_dt, end_dt, s_kd, t_wd, sort, asc);
	int fine_size = fines.size();
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
	/* Title 고정 */
	function setupEvents(){
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init(){		
		setupEvents();
	}
	
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.ch_l_cd.length;
		var cnt = 0;
		var idnum ="";
		var allChk = fm.ch_all;
		 for(var i=0; i<len; i++){
			var ck = fm.ch_l_cd[i];
			 if(allChk.checked == false){
				ck.checked = false;
			}else{
				ck.checked = true;
			} 
		} 
	}	
	//결과 선택
	function f_reslt_cng(doc_id, f_result){
		send_msg(doc_id);
		var url = '/fms2/credit/settle_doc_mng_sc_in_a.jsp?doc_id='+doc_id+'&f_result='+f_result+'&choice=result';
		var specs = "left=10,top=10,width=572,height=166";
		  specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
		 window.open(url, "popup", specs);
	}
	//사유 선택
	function f_reason_cng(doc_id, f_reason){
		var url = '/fms2/credit/settle_doc_mng_sc_in_a.jsp?doc_id='+doc_id+'&f_reason='+f_reason+'&choice=reason';
		var specs = "left=10,top=10,width=572,height=166";
		  specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
		 window.open(url, "popup", specs);
	}
	
	function send_msg(doc_id){
		var url = '/fms2/credit/settle_doc_mng_sc_in_a.jsp?doc_id='+doc_id+'&send_msg=Y';
		var specs = "left=10,top=10,width=572,height=166";
		  specs += ",toolbar=no,menubar=no,status=no,scrollbars=no,resizable=no";
		 window.open(url, "popup", specs);
	}
</script>
<script>
$(document).ready(function() {
	//파일 업로드 관련
	$('#upload-select-fake').bind('click', function() {
		removefile();
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
         $('#upload-list pre').append(list);
         
         for (var i = 0; i < this.files.length; i++) {
	         var file = this.files[i];
	         var tokens = file.name.split('.');
	         tokens.pop();
	         
	         var gubun_nm = '<%=gubun_nm%>';
	         
	         var content_seq = gubun_nm+tokens.join(); 
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
         
         //file 
        // $('#form2').append($('#upload-select').clone());
      
         
       /*   for(var i =0; i < pevFileNames.length; i++){
             $('#form2').append('<input type="hidden" name="pevFileNames" id="pevFileNames" value="'+pevFileNames[i]+'">');
         } */
         
		});
	
		$('#upload-button-fake').bind('click', function() {
		
		       if(!confirm("해당 파일을 등록하시겠습니까?")) return;
		       var refresh=false;
		       if(validation()){
		          $("#form2").attr("action", "https://fms3.amazoncar.co.kr/fms2/attach/multifileupload.jsp?contentCode=FINE_DOC");//실제사용
		        //  $("#form2").attr("action", "/fms2/attach/multifileupload.jsp?contentCode=FINE_DOC"); //테스트용
		          $("#form2").attr("target","_blank");
		          $("#form2").submit();
		          refresh=true;	
		       }
		       if(refresh){
		    	   setTimeout(function() {
						parent.document.location.reload();// 프레임새로고침
					}, 2000);
				}
		          
		   });
	});
	
	//리스트 삭제
	function removefile(){
		$('#form2').children('#upload-select').remove();
		//$('#form2').children('#pevFileNames').remove();
		$('#form2').find('#file-upload-form').find('tr').remove();
		$('#upload-list').children('pre').empty();
	}

	//요청
	function select_ins_com(){
		var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var act_ment="";
		var chk_value="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;
				}
			}
		}	
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
		
		fm.size.value = document.form1.size.value;
		
		act_ment="일괄인쇄";
				
		if(confirm(act_ment+' 하시겠습니까?')){
			 window.open("" ,"form1", 
		       "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
			
			fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/ins_com_file_print.jsp";
			//fm.target = "_blank";
			fm.target = "form1";
			fm.method="post";
			fm.submit();	
		}
	}			
	
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

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='doc_cnt' value=''>
<input type='hidden' name='fee_size' value='<%=fine_size%>'>

<%if(gubun1.equals("1")){ %>    
<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("최고장발송",ck_acar_id) ){  %>      
<!--파일 업로드  -->
<div class="search-area" style="display: inline-block;margin:0px;margin-left:100px;">
    <input type="button" id="upload-select-fake" class="button" value="파일 선택"/>
    <input type="button" id="upload-button-fake" class="button btn-submit" value="업로드"/>
    <input style="display: none;" id="upload-select" type="file" name="files[]" multiple>
</div>
<%} %>
<%} %>
<div style="margin-left:20px;" id="upload-list"><pre style="font-size: 10.5pt;display: inline-block;"></pre></div>
<div style="margin-bottom:10px;">
<span style="font-size:9pt;color:#464e7c;font-weight: bold;margin-left:20px;">※ 결과 적용시 해당문서에 대한 메세지가 담당자에게 전달 됩니다.</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width='1340'>
  <tr>
    <td colspan=2 class=line2></td>
 </tr>
  <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='470' id='td_title' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='470'>
          <tr> 
          	<td class='title' ><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
            <td class='title' width="30">연번</td>
            <td width='120' class='title'>문서번호</td>
            <td width='120' class='title'>시행일자</td>
            <td width='180' class='title'>수신처</td>
          </tr>
        </table>
	</td>
	<td class='line' width='860'>			
        <table border="0" cellspacing="1" cellpadding="0" width='870'>
          <tr> 
            <td width='200' class='title'>제목</td>			
            <td class='title' width="60">미수채권</td>
            <td class='title' width="100">유예기간</td>
            <td class='title' width="70">결과</td>
            <td class='title' width="70">공문</td>
            <td class='title' width="70">메일</td>
            <td class='title' width="100">스캔</td>	      
            <td class='title' width="100">사유</td>
            <td class='title' width="60">메세지</td>
           	
          </tr>
        </table>
	</td>
  </tr> 
  
  <tr>
	<td class='line' width='470' id='td_con' style='position:relative;'>			
        <table border="0" cellspacing="1" cellpadding="0" width='470'>
          <%for(int i = 0 ; i < fine_size ; i++){
				Hashtable ht = (Hashtable)fines.elementAt(i);%>
          <tr> 
          	<td align='center'>
			          	<input type="checkbox" name="ch_l_cd" value="<%=i%>">
			          	<input type='hidden' name='ch_doc_id' value='<%=ht.get("DOC_ID")%>'>
			          	<input type='hidden' name='ch_cnt' value='<%=ht.get("CNT")%>'>
	        </td>
            <td  align='center' width="30"><%=i+1%></td>
            <td  width='120' align='center'>
            <% if (ht.get("ID_ST").equals("2")  ) { %>
			<a href="javascript:parent.view_fine_doc3('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a>
			<% } else { %>
			<a href="javascript:parent.view_fine_doc('<%=ht.get("DOC_ID")%>', '<%=ht.get("GOV_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("DOC_ID")%></a>
		    <% } %>
			</td>
            <td  width='120' align='center'><%=AddUtil.getDate3(String.valueOf(ht.get("DOC_DT")))%></td>
            <td  width='180' align='center'><%=Util.subData(String.valueOf(ht.get("GOV_NM")), 14)%></td>
          </tr>
          <%}%>
		  <%if(fine_size==0){%>
            <td  align='center'>등록된 데이타가 없습니다.</td>		  
          <%}%>		  
        </table>
	</td>
	<td class='line' width='860'>			
        <table border="0" cellspacing="1" cellpadding="0" width='870'>
          <%for(int i = 0 ; i < fine_size ; i++){
				Hashtable ht = (Hashtable)fines.elementAt(i);
				%>
          <tr> 
            <td width='200' align='center'><%=ht.get("TITLE")%></td>			 
            <td align="center" width="60"><%=ht.get("CNT")%>건</td>
            <td align="center" width="100"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%></td>
            <td align="center" width="70">
       		<%if(gubun1.equals("1") && (nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("최고장발송",ck_acar_id))){  %>      
			 <select name="f_result" style="width:50px;" onchange="f_reslt_cng('<%=ht.get("DOC_ID")%>',this.value)">
			    <option value="" <% if(ht.get("F_RESULT").equals("")){%>selected<%}%>></option>
                <option value="1" <% if(ht.get("F_RESULT").equals("1")){%>selected<%}%>>반송</option>
				<option value="2" <% if(ht.get("F_RESULT").equals("2")){%>selected<%}%>>도착</option>
              </select>
              <%}else{ %>
                 <% if (ht.get("F_RESULT").equals("1")) { %>
					<font color='red'>	<span title="<%=ht.get("F_REASON_NM")%>">반송</span></font>
				<%}else if (ht.get("F_RESULT").equals("2")) { %>
						<span title="<%=ht.get("F_REASON_NM")%>">도착</span>
				<% } else { %>&nbsp;<% } %>
              <%} %>
			</td>
		    <td align="center" width="70">		   
	            <% if ( ht.get("TITLE").equals("대차료 차액분 납부최고") || ht.get("TITLE").equals("계약해지 및 납부최고") || ht.get("TITLE").equals("계약해지 및 차량반납 통보") || ht.get("TITLE").equals("해지통보 및 해지정산금 납입고지")) { %>
	            	<a href="javascript:parent.FineDocPrint('<%=ht.get("DOC_ID")%>', '<%=ht.get("TITLE")%>')"><img src="/acar/images/center/button_in_print.gif" align="absmiddle" border="0"></a> 
	            <%} %>	        
            </td>
            <td align="center" width="70">          
	            <% if (ht.get("TITLE").equals("계약해지 및 납부최고") || ht.get("TITLE").equals("계약해지 및 차량반납 통보") || ht.get("TITLE").equals("해지통보 및 해지정산금 납입고지")) { %>
	            	<a href="javascript:parent.doc_email_view('<%=ht.get("DOC_ID")%>', '<%=ht.get("TITLE")%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
	            <%} %>
            </td>
            <td align="center" width="100">
					<%if(!(ht.get("FILE_NAME")+"").equals("")){%>
						<%if((ht.get("FILE_TYPE")+"").equals("image/jpeg")||(ht.get("FILE_TYPE")+"").equals("image/pjpeg")||(ht.get("FILE_TYPE")+"").equals("application/pdf")){%>
							<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("FILE_SEQ")%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
						<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=ht.get("FILE_SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
						<%}%>
					 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("FILE_SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
					<%}%> 
            </td>			
             <td align="center" width="100">
             	<%if(gubun1.equals("1")){ %>    
           		<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("최고장발송",ck_acar_id)){  %>      
           	  <select name="f_reason" onchange="f_reason_cng('<%=ht.get("DOC_ID")%>',this.value)">
			    <option value="" <% if(ht.get("F_REASON").equals("")){%>selected<%}%>></option>
                <option value="1" <% if(ht.get("F_REASON").equals("1")){%>selected<%}%>>이사감</option>
                <option value="2" <% if(ht.get("F_REASON").equals("2")){%>selected<%}%>>수취인부재</option>
                <option value="3" <% if(ht.get("F_REASON").equals("3")){%>selected<%}%>>폐문부재</option>
                <option value="4" <% if(ht.get("F_REASON").equals("4")){%>selected<%}%>>수취거절</option>
                <option value="5" <% if(ht.get("F_REASON").equals("5")){%>selected<%}%>>주소불명</option>
                <option value="6" <% if(ht.get("F_REASON").equals("6")){%>selected<%}%>>수취인불명</option>    
               	<%}else{%>
           			<%if(ht.get("F_REASON").equals("1")){%>
	               		<span>이사감</span>
               		<%}else if(ht.get("F_REASON").equals("2")){%>
	               		<span>수취인부재</span>
               		<%}else if(ht.get("F_REASON").equals("3")){%>
	               		<span>폐문부재</span>
               		<%}else if(ht.get("F_REASON").equals("4")){%>
	               		<span>수취거절</span>
               		<%}else if(ht.get("F_REASON").equals("5")){%>
	               		<span>주소불명</span>
               		<%}else if(ht.get("F_REASON").equals("6")){%>
	               		<span>수취인불명</span>
               		<%}else{%>

	           		<%}%>          
           		<%}%>          
           		<%}%>          
              </select>
            </td>	
            
           	<td align="center" width="60">  
           	<%if(gubun1.equals("1")){ %>    
           	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("최고장발송",ck_acar_id)) {  %>  
	           <a href="javascript:send_msg('<%=ht.get("DOC_ID")%>')"><img src="/acar/images/center/button_in_msg.gif" align="absmiddle" border="0"></a>
           	<%}%>
           	<%}%>
            </td>		
          </tr>
          <%}%>		  
		  <%if(fine_size==0){%>
            <td  colspan=9 align='center'></td>		  
          <%}%>
       			  
        </table>
	</td>
  </tr>
</table>
</form>
<!--파일업로드 정보  -->
<form name="form2" id="form2" action="" method="post" enctype="multipart/form-data">
	<div>
		<table id="file-upload-form" style="display: block;"></table>
	</div>
</form>
</body>
</html>
