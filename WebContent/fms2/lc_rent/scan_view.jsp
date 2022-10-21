<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*,acar.common.*, acar.client.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "01", "01", "09");
	
	
	//스캔관리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String file_st  = request.getParameter("file_st")==null?"":request.getParameter("file_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(base.getCar_mng_id());
	
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(m_id, l_cd);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	//코드리스트 : 계약스캔파일구분
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
	
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	//수정기한
	String today = AddUtil.getDate(4);
	String modify_deadline = "";
	String delete_yn = "N";
	
	//미개시이거나 개시30일이내이면 삭제권한 있음
	if(!f_fee.getRent_start_dt().equals("")){
		modify_deadline = rs_db.addDay(f_fee.getRent_start_dt(), 30);
		if(AddUtil.parseInt(modify_deadline) > AddUtil.parseInt(today)){
			delete_yn = "Y";
		}
	}else{
		delete_yn = "Y";
	}
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	
	function save(){
		fm = document.form1;

		if(fm.file_st.value == ""){	alert("구분을 선택해 주세요!");		fm.file_st.focus();	return;		}		
		if(fm.file.value == ""){	alert("파일을 선택해 주세요!");		fm.file.focus();	return;		}		
		
		<% //if ( !base.getCar_st().equals("4"))  { %>	 
			// file_st :38  tif check
			if (fm.file_st.value == "38" ) {  //cms 동의서
				   var  str_dotlocation,str_ext,str_low, str_value;
				    str_value  = fm.file.value;
				  
				    str_low   = str_value.toLowerCase(str_value);
				    str_dotlocation = str_low.lastIndexOf(".");
				    str_ext   = str_low.substring(str_dotlocation+1);
				
				    if  ( str_ext == 'tif'  ||  str_ext == 'jpg'  || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
				    } else {
					      alert("tif  또는 jpg만 등록됩니다." );
					      return false; 
				    }   			
			}else if (fm.file_st.value == "2" || fm.file_st.value == "4" || fm.file_st.value == "17" || fm.file_st.value == "18" || fm.file_st.value == "10" || fm.file_st.value == "27" || fm.file_st.value == "37" || fm.file_st.value == "15" || fm.file_st.value == "51" || fm.file_st.value == "52") {  //jpg계약서, 사업자등록증, 세금계산서, 차량이용자확인요청서, 개인(신용)정보 수집.이용.제공.조회동의서jpg, 매매주문서
				var  str_dotlocation,str_ext,str_low, str_value;
				    str_value  = fm.file.value;
				  
				    str_low   = str_value.toLowerCase(str_value);
				    str_dotlocation = str_low.lastIndexOf(".");
				    str_ext   = str_low.substring(str_dotlocation+1);
			if  ( str_ext == 'gif'  ||  str_ext == 'jpg'   || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				
			} else {
				alert("jpg  또는 gif만 등록됩니다." );
				return;
			}
		}
		
		<%// } %>
		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value+''+fm.file_st.value;
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();

	}
	
	//스캔관리 보기
	function view_scan_client(){
		window.open("view_scan_client.jsp?client_id=<%=base.getClient_id()%>", "VIEW_CLIENT_SCAN", "left=200, top=100, width=820, height=800, scrollbars=yes");		
	}

	//메일수신하기
	function go_mail(content_st, rent_st){			
		var SUBWIN="mail_input.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st="+rent_st+"&content_st="+content_st;	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}	
	
	//거래치 기존스캔 동기화
	function scan_sys(){
		var fm = document.form2;
		fm.idx.value = 'scan_sys';
		if(confirm('스캔파일 동기화하시겠습니까?')){	
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}

//-->
</script>
</head>
<body>
<div style="margin:auto; text-align:center;">
<div style="vertical-align:middle; display:inline-block">
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="fee_size" value="<%=fee_size%>">    
<input type='hidden' name="seq" value="">

<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='20%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='50%'>&nbsp;<%=est.get("FIRM_NM")%>&nbsp;<%=est.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
				%>
                <tr>
                    <td class='title'>대여개월</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>개월<%if(i>1){%>(연장)<%}%></td>
					<td class='title'>대여기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>				
                </tr>						
				<%}%>
                <tr> 
					<td class='title'>전화번호</td>
                    <td colspan=''>&nbsp;<%=est.get("O_TEL")%></td>
                    <td class='title'>우편물주소</td>
                    <td colspan=''>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='6%'>연번</td>
                    <td class="title" width='7%'>계약</td>
                    <td class="title" width='30%'>구분</td>                    
                    <td class="title" width='30%'>파일보기</td>
                    <td class="title" width='20%'>등록일</td>
                    <td class="title" width='7%'>삭제</td>
                </tr>
                <%//개별소비세 인하로 인해 한시적 오픈
                	if(fee_size==1 && base.getDlv_dt().equals("")){%>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">자동차대여이용계약서</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>		  
                  <td align="center"></td>		  
                </tr>	                     
                <%}%>
                <!--
        	<%if(base.getCar_st().equals("4")){%>        	
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>		  
                  <td align="center">자동차대여이용계약서</td>                  
                  <td align="center">
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(월렌트) 웹페이지</td>
                  <td align="center"></td>
                </tr>	        	
        	<%}else{%>        	
        	<%	for(int f=1; f<=fee_size; f++){
        			ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(f));
        	%>        	
        	<%		if(f==1 && f==fee_size){//증,대차%>        	
        	<%			if(!base.getRent_st().equals("1") && AddUtil.parseInt(fees.getRent_dt()) > 20140101 ){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">자동차대여이용계약서</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(대차,증차) 웹페이지</td>		  
                  <td align="center"></td>		  
                </tr>	        	
        	<%			}%>        	
        	<%		}else{//마지막연장%>        	
        	<%			if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f==fee_size ){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">자동차대여이용계약서</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">(연장) 웹페이지</td>		  
                  <td align="center"></td>		  
                </tr>	                	
        	<%			}%>        	
        	<%		}%>        	        	        	
        	<%	}%>
        	<%}%>
        	-->
        	
        	<%if(fee_size>1){ %>
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>
                  <td align="center">자동차대여이용계약서(연장)</td>
                  <td align="center">
		      웹페이지 <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=<%=fee_size%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"><a href=javascript:go_mail('newcar_doc','<%=fee_size%>');><img src=/acar/images/center/button_email_renew.gif border=0></a></td>		  
                  <td align="center"></td>		  
                </tr>	         	
        	<%} %>
        	                
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 					
 					String file_type1 = String.valueOf(ht.get("FILE_TYPE"));
 					
 					if(!rent_st.equals("1")){
 						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, rent_st);
 						//미개시이거나 개시30일이내이면 삭제권한 있음
						modify_deadline = rs_db.addDay(fees.getRent_start_dt(), 30);
						if(AddUtil.parseInt(modify_deadline) > AddUtil.parseInt(today)){
							delete_yn = "Y";
						}
 					}
 		%>                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center">
                        <%if(rent_st.equals("1") || rent_st.equals("")){%>신규
			<%}else{%><%=AddUtil.parseInt(rent_st)-1%>차연장<%}%>
    		    </td>					
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%>
                    	<%if(file_st.equals("55")){ //튜닝승인신청서%>
                    	<%	if(file_type1.equals("image/tiff")||file_type1.equals("image/gif")||file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")){%>
                    		&nbsp;&nbsp;<a href="/acar/car_register/doc_print_stamp.jsp?file_st=55&file_info=<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" target='_blank'><img src="/images/esti_detail.gif"  width="14" height="15" align="absmiddle" border="0" alt="인쇄화면"></a>
                    	<%	} %>
                    	<%} %>
                    </td>
                    <td align="center">
                        <%if(file_type1.equals("image/tiff")||file_type1.equals("image/gif")||file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
                    		<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    	<%}else{%>
							<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><%=ht.get("FILE_NAME")%></a>
						<%}%>
                    </td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                    <td align="center">
                        <%if(file_st.equals("1")||file_st.equals("2")||file_st.equals("4")||file_st.equals("9")||file_st.equals("17")||file_st.equals("18")){ //주요스캔을 제외하고 스캔자가 삭제할수 있다.%>
	                    	<%if((base.getBus_id().equals(user_id) && delete_yn.equals("Y")) || (String.valueOf(ht.get("REG_USERSEQ")).equals(user_id) && delete_yn.equals("Y")) || nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약결재",ck_acar_id)){%>
    	    	            	<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        	            	<%}%>
                        <%}else{ %>
    	    	            	<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
        	            <%}%>	
                    </td>
                </tr>
                <% 		}
    		  	}else{ %>
                <tr>
                    <td colspan="6" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr>
        <td colspan="2" align="right" class="line">
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>계약</td>
                    <td>
        			  &nbsp;<select name="file_rent_st">					  
                        <option value="1" <%if(fee_size==1){%>selected<%}%>>신규</option>
						<%for(int i = 1 ; i < fee_size ; i++){%>
                        <option value="<%=i+1%>" <%if(fee_size==(i+1) && ( file_st.equals("1") || file_st.equals("17") || file_st.equals("18") )){%>selected<%}%>><%=i%>차연장</option>						
						<%}%>
                      </select> 			
                    </td>
                </tr>			
                <tr>
                    <td class='title' width='15%'>구분</td>
                    <td width='85%'>&nbsp;
		      <%if(file_st.equals("") && ck_acar_id.equals("000031")) file_st="10";//이의상반장은 과태료첨부서류->대여개시후계약서(앞)jpg 디폴트%>
        	      <select name="file_st">
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>스캔파일</td>
                    <td>&nbsp;
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=m_id%><%=l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <!-- 
    <tr>
        <td colspan="2">☞ 2010년5월1일 부터 대여개시후계약서, 사업자등록증, 신분증 스캔을 JPG로 하지 않으실 경우 스캔 등록이 되지 않습니다.</td>
    </tr>
     -->	
    <tr>
        <td colspan="2">☞ <b>대여개시후계약서(앞/뒤)jpg</b>는 <b>차량번호, 대여개시일, 대여만료일</b>이 작성된것으로 스캔하세요.</td>
    </tr>
    <!-- 			
    <tr>
        <td colspan="2">☞ <b>자동차매입세금계산서도 jpg</b>로 스캔등록하세요.(2012-04-09)</td>
    </tr>	
    <tr>
        <td colspan="2">☞ <b>매매주문서도 jpg</b>로 스캔등록하세요.(2021-03-16)</td>
    </tr>
     -->			
    <tr>
        <td colspan="2">☞ <b>파일구분 추가는  IT마케팅팀에 요청하세요.</b></td>
    </tr>   
    <%if(delete_yn.equals("N")){%>   
    <tr>
        <td colspan="2">☞ <b>파일삭제는 영업팀장에게 요청하세요.</b></td>
    </tr>         
    <%}%>    
    <tr>
        <td colspan="2" align="right">
            <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" style='background-color:bebebe; height:1;'></td>
    </tr>
    <tr>
        <td></td>
    </tr>	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객별 최근 스캔</span></td>
        <td align="right"><a href='javascript:view_scan_client()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_more.gif border=0 align=absmiddle></a></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%if(client.getClient_st().equals("1")){//법인%>
                <tr> 
                    <td class='title' width='15%'>사업장주소</td>
                    <td>&nbsp;<%=client.getO_zip()%> &nbsp;<%=client.getO_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title' width='15%'>본점주소</td>
                    <td>&nbsp;<%=client.getHo_zip()%> &nbsp;<%=client.getHo_addr()%></td>
                </tr>
                <tr> 
                    <td class='title'>대표자주소</td>
                    <td>&nbsp;<%=client.getRepre_zip()%> &nbsp;<%=client.getRepre_addr()%> [<%=client.getClient_nm()%>]</td>
                </tr>                
                <%}else if(client.getClient_st().equals("2")){//개인%>
                <tr> 
                    <td class='title' width='15%'>자택주소</td>
                    <td>&nbsp;<%=client.getHo_zip()%> &nbsp;<%=client.getHo_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title' width='15%'>직장주소</td>
                    <td>&nbsp;<%=client.getComm_zip()%> &nbsp;<%=client.getComm_addr()%> <%=client.getCom_nm()%></td>
                </tr>                                
                <%}else{%>
                <tr> 
                    <td class='title' width='15%'>사업장주소</td>
                    <td>&nbsp;<%=client.getO_zip()%> &nbsp;<%=client.getO_addr()%></td>
                </tr>                
                <tr> 
                    <td class='title'>대표자주소</td>
                    <td>&nbsp;<%=client.getRepre_zip()%> &nbsp;<%=client.getRepre_addr()%> [<%=client.getClient_nm()%>]</td>
                </tr>                                
                <%}%>
            </table>
        </td>
    </tr>  
    <%if(ck_acar_id.equals("000029")){ %>
     <tr>
        <td colspan="2" align="right">※ 고객 공동파일 동일 거래처 타계약 스캔파일과 <a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="클릭하세요">[동기화]</a></td>
    </tr>  	
    <%} %>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='6%'>연번</td>
                    <td class="title" width='37%'>구분</td>                    
                    <td class="title" width='30%'>파일보기</td>
                    <td class="title" width='27%'>등록일</td>
                </tr>
                <%
			attach_vt = c_db.getAcarAttachFileLcScanClientMaxSeqList(base.getClient_id());		
			attach_vt_size = attach_vt.size();		
                
                %>
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 										
 					Hashtable ht2 = c_db.getAcarAttachFileEqual("","",AddUtil.parseInt(String.valueOf(ht.get("SEQ"))));	
 					 					
 					if(!String.valueOf(ht2.get("CONTENT_SEQ")).equals("") && String.valueOf(ht2.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht2.get("CONTENT_SEQ")).substring(20); 						
 					}
 		%>                
                
                <tr>
                    <td align="center"><%= j+1 %></td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER")%></td>
                </tr>
                <% 		}
    		  		}else{ %>
                <tr>
                    <td colspan="4" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
	  <%if(ch_r.length > 0){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차등록증 스캔</span></td>
    </tr>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class="title" width='5%'>연번</td>
                    <td class="title" width='20%'>구분</td>
                    <td class="title" width='40%'>설명</td>
                    <td class="title" width='15%'>파일보기</td>
                    <td class="title" width='20%'>등록일</td>
                </tr>
                <%
    				for(int i=0; i<ch_r.length; i++){
    			        ch_bean = ch_r[i];
    			//	if(ch_bean.getScanfile().equals("")) continue;	
    					
    				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){	    	
		%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center">
                    자동차등록증
    			    </td>
                    <td align="center">
    			  		  <% if(ch_bean.getCha_cau().equals("1")){%>
                          사용본거지 변경 
                          <%}else if(ch_bean.getCha_cau().equals("2")){%>
                          용도변경 
                          <%}else if(ch_bean.getCha_cau().equals("3")){%>
                          기타 
                          <%}else if(ch_bean.getCha_cau().equals("4")){%>
                          없음
                          <%}else if(ch_bean.getCha_cau().equals("5")){%>신규등록<%}%>	
    			    </td>
                    <td align="center">
					<%if(attach_vt_size > 0){%>
			    			<%	for (int j = 0 ; j < attach_vt_size ; j++){
    								Hashtable attach_ht = (Hashtable)attach_vt.elementAt(j);    								
    						%>
    							&nbsp;<a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>    							
    						<%	}%>		    			
    						<%}%> 				
					 </td>
                    <td align="center"><%=ch_bean.getCha_dt()%><%=c_db.getNameById(ch_bean.getReg_id(),"USER")%></td>
                </tr>
                <% 		}%>
                <% 	}%>
            </table>
        </td>
    </tr>	  
     <% 	} %>	  	  
</table>
</form>
<form name='form2' action='' method='post'>
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="rent_mng_id" value="<%=m_id%>">
<input type='hidden' name="rent_l_cd" value="<%=l_cd%>">    
<input type='hidden' name="from_page2" value="/fms2/lc_rent/scan_view.jsp">
<input type='hidden' name="idx" value="">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</div>
</div>
</body>
</html>