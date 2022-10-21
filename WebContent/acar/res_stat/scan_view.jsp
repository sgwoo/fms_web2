<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*,acar.car_register.*,acar.common.*, acar.client.*, acar.res_search.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 페이지
	
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String s_cd 	= request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String rent_st 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String file_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	String user_id = login.getCookieValue(request, "acar_id");
	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	rent_st = rc_bean.getRent_st();
	
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	
	//고객정보
	ClientBean client = al_db.getNewClient(rc_bean.getCust_id());
	
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	
	String content_code = "SC_SCAN";
	String content_seq  = c_id+""+s_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();		
	
	
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
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_st.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.SC_SCAN%>";				
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name="user_id" value="<%=user_id%>">
<input type='hidden' name="c_id" value="<%=c_id%>">
<input type='hidden' name="s_cd" value="<%=s_cd%>">
<input type='hidden' name="from_page" 	value="<%=from_page%>">  
<table border="0" cellspacing="0" cellpadding="0" width=670>
    <tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>예약시스템 스캔관리 (<%=c_id%>)</span></span></td>
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
	      
    <tr> 
        <td colspan="2" class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='20%'>&nbsp;<%=s_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='50%'>&nbsp;<%=client.getFirm_nm()%> <%=client.getClient_nm()%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%></td>
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
                    <td class="title" width='10%'>연번</td>                    
                    <td class="title" width='25%'>구분</td>                    
                    <td class="title" width='25%'>파일보기</td>
                    <td class="title" width='30%'>등록일</td>
                    <td class="title" width='10%'>삭제</td>
                </tr>
                
                <% 	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j); 
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 12){
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(12);
 					}
 		%>
                <tr>
                    <td align="center"><%= j+1 %></td>			
                    <td align="center">
                    	<%if(file_st.equals("1")){%>최초계약서<%}%>
                    	<%if(file_st.equals("17")){%>대여개시후계약서(앞)<%}%>
                    	<%if(file_st.equals("18")){%>대여개시후계약서(뒤)<%}%>					
                    	<%if(file_st.equals("2")){%>사업자등록증<%}%>
                    	<%if(file_st.equals("3")){%>법인등기부등본<%}%>
                    	<%if(file_st.equals("6")){%>법인인감증명서<%}%>
                    	<%if(file_st.equals("4")){%>신분증<%}%>
                    	<%if(file_st.equals("7")){%>주민등록등본<%}%>
                    	<%if(file_st.equals("8")){%>인감증명서<%}%>
                    	<%if(file_st.equals("9")){%>통장사본<%}%>
                    	<%if(file_st.equals("10")){%>세금계산서<%}%>
                    	<%if(file_st.equals("5")){%>기타<%}%>
                    	<%if(file_st.equals("11")){%>보증인신분증<%}%>
                    	<%if(file_st.equals("12")){%>보증인등본<%}%>
                    	<%if(file_st.equals("13")){%>보증인인감<%}%>												
                    	<%if(file_st.equals("14")){%>연대보증서<%}%>	
                    	<%if(file_st.equals("15")){%>매매주문서<%}%>
                    	<%if(file_st.equals("16")){%>과태료첨부서류<%}%>
			<%if(file_st.equals("19")){%>보험가입특약서<%}%>
			<%if(file_st.equals("20")){%>이전계약자인감증명서<%}%>					
			<%if(file_st.equals("21")){%>보험계약사항변경요청서<%}%>					
			<%if(file_st.equals("22")){%>대여료계약사항변경요청서<%}%>					
			<%if(file_st.equals("24")){%>주운전자운전면허증<%}%>
			<%if(file_st.equals("25")){%>배차차량인도증<%}%>
			<%if(file_st.equals("26")){%>반차차량인수증<%}%>
			<%if(file_st.equals("27")){%>추가운전자운전면허증<%}%>
			<%if(file_st.equals("28")){%>기본식유상정비대차견적서<%}%>
    		    </td>                    
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
                    <td align="center">
                        <%if(file_st.equals("1")||file_st.equals("2")||file_st.equals("4")||file_st.equals("9")||file_st.equals("17")||file_st.equals("18")){ //주요스캔을 제외하고 스캔자가 삭제할수 있다.%>
	                    	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약결재",ck_acar_id)){%>
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
                    <td colspan="5" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
                </tr>
                <% 	} %>
            </table>
        </td>
    </tr>
    <%
    	file_st = "";
    %>
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
                    <td class='title' width='15%'>구분</td>
                    <td width='85%'>&nbsp;
        	        <select name="file_st">
                            <option value="1" <%if(file_st.equals("1")){%>selected<%}%>>최초계약서</option>
                            <option value="17" <%if(file_st.equals("17")){%>selected<%}%>>대여개시후계약서(앞)jpg</option>						
                            <option value="18" <%if(file_st.equals("18")){%>selected<%}%>>대여개시후계약서(뒤)jpg</option>												
                            <option value="2" <%if(file_st.equals("2")){%>selected<%}%>>사업자등록증jpg</option>
                            <option value="3" <%if(file_st.equals("3")){%>selected<%}%>>법인등기부등본</option>				
                            <option value="6" <%if(file_st.equals("6")){%>selected<%}%>>법인인감증명서</option>								
                            <option value="4" <%if(file_st.equals("4")){%>selected<%}%>>신분증jpg</option>				
                            <option value="7" <%if(file_st.equals("7")){%>selected<%}%>>주민등록등본</option>				
                            <option value="8" <%if(file_st.equals("8")){%>selected<%}%>>인감증명서</option>		
                            <option value="14" <%if(file_st.equals("14")){%>selected<%}%>>연대보증서</option>														
                            <option value="11" <%if(file_st.equals("11")){%>selected<%}%>>보증인신분증</option>				
                            <option value="12" <%if(file_st.equals("12")){%>selected<%}%>>보증인등본</option>				
                            <option value="13" <%if(file_st.equals("13")){%>selected<%}%>>보증인인감증명서</option>																				
                            <option value="9" <%if(file_st.equals("9")){%>selected<%}%>>통장사본</option>
                            <option value="5" <%if(file_st.equals("5")){%>selected<%}%>>기타</option>				
                            <option value="24" <%if(file_st.equals("24")){%>selected<%}%>>주운전자운전면허증</option>
                            <option value="25" <%if(file_st.equals("25")){%>selected<%}%>>배차차량인도증</option>
                            <option value="26" <%if(file_st.equals("26")){%>selected<%}%>>반차차량인수증</option>
                            <option value="27" <%if(file_st.equals("27")){%>selected<%}%>>추가운전자운전면허증</option>
                            <option value="28" <%if(file_st.equals("28")){%>selected<%}%>>기본식유상정비대차견적서</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td class='title'>스캔파일</td>
                    <td>                        
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=c_id%><%=s_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.SC_SCAN%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="right"><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2" align="right"></td>
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
    				
    				if(ch_bean.getScanfile().equals("")) continue;	
    		
				//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
				content_code = "CAR_CHANGE";
				content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();

				attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
				attach_vt_size = attach_vt.size();
				
				if(attach_vt_size > 0){	    					
    		%>
                <tr>
                    <td align="center"><%= i+1 %></td>
                    <td align="center">자동차등록증</td>
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
    <%}%>	  	  
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</body>
</html>
