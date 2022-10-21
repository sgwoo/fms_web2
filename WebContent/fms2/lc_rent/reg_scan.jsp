<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String file_st	 	= request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String file_cont 	= request.getParameter("file_cont")==null?"":request.getParameter("file_cont");
	
	String idx		= request.getParameter("idx")==null?"":request.getParameter("idx");
	String rent_st		= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_mng_id2 	= request.getParameter("rent_mng_id2")==null?"":request.getParameter("rent_mng_id2");
	String rent_l_cd2 	= request.getParameter("rent_l_cd2")==null?"":request.getParameter("rent_l_cd2");
	
	
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//코드리스트 : 계약스캔파일구분
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
	
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
		if(fm.file.value == ""){		alert("파일을 선택해 주세요!");		fm.file.focus();		return;		}
		
		var str_dotlocation,str_ext,str_low, str_value;
    str_value  			= fm.file.value;
    str_low   			= str_value.toLowerCase(str_value);
    str_dotlocation = str_low.lastIndexOf(".");
    str_ext   			= str_low.substring(str_dotlocation+1);

		if (fm.file_st.value == "38" ) {  //cms 동의서
				
			if  ( str_ext == 'tif'  ||  str_ext == 'jpg'  || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
				var conStr = "cms 동의서의 파일용량은 300Kb로 제한됩니다.";
				if(confirm(conStr)==true){
					
				}else{
					return;
				}
			} else {
				alert("tif  또는 jpg만 등록됩니다." );
				return;
			}
			
		}else if (fm.file_st.value == "2" || fm.file_st.value == "4" || fm.file_st.value == "17" || fm.file_st.value == "18" || fm.file_st.value == "10" || fm.file_st.value == "27" || fm.file_st.value == "37" || fm.file_st.value == "15" || fm.file_st.value == "51" || fm.file_st.value == "52") {  //jpg계약서, 사업자등록증, 세금계산서, 차량이용자확인요청서, 개인(신용)정보 수집.이용.제공.조회동의서jpg, 매매주문서
				
			if  ( str_ext == 'gif'  ||  str_ext == 'jpg'   || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				
			} else {
				alert("jpg  또는 gif만 등록됩니다." );
				return;
			}
		}
		

		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
	
		fm.<%=Webconst.Common.contentSeqName%>.value = fm.<%=Webconst.Common.contentSeqName%>.value+''+fm.file_rent_st.value+''+fm.file_st.value;
						
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();
	}
	
//-->
</script>
</head>

<body onload='javascript:document.form1.file_cont.focus();'>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  
  <input type='hidden' name="idx"			value="<%=idx%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="from_page" 	value="<%=from_page%>">  
  <input type='hidden' name="fee_size" 		value="<%=fee_size%>">    
  <input type='hidden' name="seq" 		value="">
  <input type='hidden' name="copy_path"		value="">
  <input type='hidden' name="copy_type"		value="">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>  
    <tr>
	    <td class=line2></td>
	</tr>
	      <%	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);%>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='15%'>계약번호</td>
                    <td width='25%'>&nbsp;<%=rent_l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td>&nbsp;<%=est.get("FIRM_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=est.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=est.get("CAR_NM")%> <%=est.get("CAR_NAME")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title' width='15%'>계약</td>
                    <td>&nbsp;
                      <select name="file_rent_st">					  
                        <option value="1" <%if(fee_size==1){%>selected<%}%>>신규</option>
						<%for(int i = 1 ; i < fee_size ; i++){%>
                        <option value="<%=i+1%>" <%if(fee_size==(i+1)){%>selected<%}%>><%=i%>차연장</option>						
						<%}%>
                      </select>
                    </td>
                </tr>			
                <tr>
                    <td class='title' width='15%'>구분</td>
                    <td>&nbsp;
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
                    <td>
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(file_st.equals("21")){%>
    <tr>
        <td>☞ 설명에 있는 데이타는 보험변경문서번호이니 수정하지 마세요.</td>
    </tr>		
	<%}else if(file_st.equals("22")){%>
    <tr>
        <td>☞ 설명에 있는 데이타는 대여료변경문서번호이니 수정하지 마세요.</td>
    </tr>		
	<%}else{%>
    <tr>
        <td>☞ 2010년5월1일 부터 대여개시후계약서, 사업자등록증, 신분증 스캔을 JPG로 하지 않으실 경우 스캔 등록이 되지 않습니다.</td>
    </tr>	
    <tr>
        <td>☞ <b>대여개시후계약서(앞/뒤)jpg</b>는 <b>차량번호, 대여개시일, 대여만료일</b>이 작성된것으로 스캔하세요.</td>
    </tr>
    <tr>
        <td>☞ <b>자동차매입세금계산서도 jpg</b>로 스캔등록하세요.(2012-04-09)</td>
    </tr>			
    <tr>
        <td>☞ <b>매매주문서도 jpg</b>로 스캔등록하세요.(2021-03-16)</td>
    </tr>	
    <tr>
        <td>☞ 설명란이 없습니다. 파일 이름에 설명부분 추가하여 수정하시고 등록하십시오.</td>
    </tr>  		
    <tr>
        <td>☞ <b>파일구분 추가는  IT마케팅팀에 요청하세요.</b></td>
    </tr>      
    
	<%}%>
    <tr>
        <td align="right">
            <%//if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
            <a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <%//}%>
            <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> </iframe>
</body>
</html>
