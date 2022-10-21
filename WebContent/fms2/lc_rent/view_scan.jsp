<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*, acar.user_mng.*,acar.common.*, acar.client.*,acar.insur.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	LoginBean login = LoginBean.getInstance();

	//스캔관리 페이지
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String file_st  = request.getParameter("file_st")==null?"":request.getParameter("file_st");	

	
	
	//로그인ID&영업소ID
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	
	
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
	InsComDatabase ic_db = InsComDatabase.getInstance();
	Vector attach_vt2 = ic_db.getInsComFileList(base.getCar_mng_id());	
    
	//attach_vt.addAll(attach_vt2); 
	int attach_vt_size = attach_vt.size();		
	int attach_vt2_size = attach_vt2.size();		
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.file_st.value == ""){		alert("구분을 선택해 주세요!");		fm.file_st.focus();		return;		}
		else if(fm.file_name == ""){	alert("파일을 선택해 주세요!");		fm.file_name.focus();	return;		}
		
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
			}		
		
		<%// } %>
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
//		fm.target = "i_no";
		fm.submit();
	}
	
	
	//스캔관리 보기
	function view_scan_client(){
		window.open("view_scan_client.jsp?client_id=<%=base.getClient_id()%>", "VIEW_CLIENT_SCAN", "left=200, top=100, width=820, height=800, scrollbars=yes");		
	}
	
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='scan_view_a.jsp' method='post' enctype="multipart/form-data">
<input type='hidden' name="m_id" value="<%=m_id%>">
<input type='hidden' name="l_cd" value="<%=l_cd%>">
<input type='hidden' name="seq" value="">

<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>스캔관리</span></span> : 스캔관리</td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
	      <%	Hashtable est = a_db.getRentEst(m_id, l_cd);%>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                  <td class='title' width='14%'>계약번호</td>
                  <td width='20%'>&nbsp;<%=l_cd%></td>
                  <td class='title' width='14%'>상호</td>
                  <td>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                  <td class='title'>차량번호</td>
                  <td>&nbsp;<%=est.get("CAR_NO")%></td>
                  <td class='title'>차명</td>
                  <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));%>
                <tr> 
                    <td class='title'>대여개월</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>개월<%if(i>1){%>(연장)<%}%></td>
                    <td class='title'>대여기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
                </tr>						
				<%}%>					
                <tr> 
                    <td class='title'>우편물주소</td>
                    <td colspan='3'>&nbsp;<%= base.getP_zip()%>&nbsp;<%= base.getP_addr()%>&nbsp;<%=base.getTax_agnt()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약별 스캔</span></td>
        <td align="right">&nbsp;</td>
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
                    <td class="title" width='27%'>등록일</td>
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
                </tr>	                     
                <%}%>                
                <!-- 
        	<%if(base.getCar_st().equals("4")){%>        	
                <tr>
                  <td align="center"></td>
                  <td align="center"></td>		  
                  <td align="center">월렌트 자동차대여이용계약서</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&rent_st=1' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"></td>
                </tr>	        	
        	<%}%>
        	-->
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
 						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 					String file_type1 = String.valueOf(ht.get("FILE_TYPE"));
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
                </tr>
                <% 		}
    		  		} %>
                <% 	if(attach_vt2_size > 0){
						for (int z = 0 ; z < attach_vt2_size ; z++){
 							Hashtable ht2 = (Hashtable)attach_vt2.elementAt(z); 
 				%>                
                <tr>
                    <td align="center"><%= attach_vt_size+z+1 %></td>
                    <td align="center">  <%if(rent_st.equals("1") || rent_st.equals("")){%>신규
                        <%}else{%><%=AddUtil.parseInt(rent_st)-1%>차연장<%}%>	  </td>					
                    <td align="center">보험가입증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a></td>
                    <% 
                    String user = "";
                    if(c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER").length()>3){
                    	user = c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER").substring(0,3);
                    }else{
                    	user =c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER");
                    }
                    %>
                    <td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=user%></td>
                </tr>
                <% 		}
    		  		}%>
   		  	   	<% 	if(attach_vt2_size == 0 && attach_vt2_size == 0){ %>
	    		  	 <tr>
	                  <td colspan="5" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
	                </tr>	
   		  		<%}%>
                
                
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객별 최근 스캔</span></td>
        <td align="right"><a href='javascript:view_scan_client()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_more.gif align=absmiddle border=0></a></td>
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
				<tr> 
                    <td class='title'>사업장전화</td>
                    <td>&nbsp;<%=client.getO_tel()%></td>
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
				<tr> 
                    <td class='title'>사업장전화</td>
                    <td>&nbsp;<%=client.getO_tel()%></td>
                </tr>
                <%}%>		
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
                    <td colspan="5" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>		
	  <%if(ch_r.length > 0){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차등록증 스캔</span></td>
        <td align="right"></td>
    </tr>	
  
    <tr>
        <td colspan="2" class=line2></td>
    </tr>
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td class="title" width='7%'>연번</td>
                  <td class="title" width='17%'>구분</td>
                  <td class="title" width='37%'>설명</td>
                  <td class="title" width='22%'>파일보기</td>
                  <td class="title" width='17%'>등록일</td>
                </tr>
                <%
    				for(int i=0; i<ch_r.length; i++){
    			        ch_bean = ch_r[i];	
//    					if(ch_bean.getScanfile().equals(""))			
//    					 continue;
    					 
    					 
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
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
