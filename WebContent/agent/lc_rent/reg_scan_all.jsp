<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.common.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" 	class="acar.fee.AddFeeDatabase"			   scope="page"/>

<%@ include file="/agent/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//스캔관리 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st		= request.getParameter("fee_rent_st")==null?"":request.getParameter("fee_rent_st");
	int    fee_size		= request.getParameter("fee_size")==null?1:AddUtil.parseInt(request.getParameter("fee_size"));
	int    h_scan_num	= request.getParameter("h_scan_num")==null?1:AddUtil.parseInt(request.getParameter("h_scan_num"));
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//대여료갯수조회(연장여부)
	fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	String content_seq = "";
	String file_st = "";
	String file_rent_st = "";
	String file_cont = "";
	
	String vid1[] 		= request.getParameterValues("ch_l_cd");	
	
	int vid_size 		= vid1.length;
	
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
		
		<%	for(int i=0;i < vid1.length;i++){%>
		if(fm.file[<%=i%>].value == ''){ 
			alert('<%=i+1%>번 파일이 없습니다. 파일을 선택하여 주십시오.'); return;
		}else{
			var str_dotlocation,str_ext,str_low, str_value;
    	str_value  			= fm.file[<%=i%>].value;
    	str_low   			= str_value.toLowerCase(str_value);
    	str_dotlocation = str_low.lastIndexOf(".");
    	str_ext   			= str_low.substring(str_dotlocation+1);
			if (fm.file_st[<%=i%>].value == "38" ) {  //cms 동의서
				if  ( str_ext == 'tif'  ||  str_ext == 'jpg' || str_ext == 'TIF'  ||  str_ext == 'JPG' ) {
					var conStr = "cms 동의서의 파일용량은 300Kb로 제한됩니다.";
					if(confirm(conStr)==true){
						
					}else{
						return;
					}
				} else {
					alert("<%=i+1%>번 파일 : tif  또는 jpg만 등록됩니다." );
					return;
				}
			}else if (fm.file_st[<%=i%>].value == "2" || fm.file_st[<%=i%>].value == "4" || fm.file_st[<%=i%>].value == "17" || fm.file_st[<%=i%>].value == "18" || fm.file_st[<%=i%>].value == "10" || fm.file_st[<%=i%>].value == "27" || fm.file_st[<%=i%>].value == "37" || fm.file_st[<%=i%>].value == "15" || fm.file_st[<%=i%>].value == "51" || fm.file_st[<%=i%>].value == "52") {  //jpg계약서, 사업자등록증, 세금계산서, 차량이용자확인요청서, 개인(신용)정보 수집.이용.제공.조회동의서jpg, 매매주문서
				if  ( str_ext == 'gif'  ||  str_ext == 'jpg'  || str_ext == 'GIF'  ||  str_ext == 'JPG' ) {
				} else {
					alert("<%=i+1%>번 파일 : jpg  또는 gif만 등록됩니다." );
					return;
				}
			}
		}		
		<%	}%>
		
		<%	if(vid1.length <12){%>
		<%		for(int i=vid1.length;i < 12;i++){%>
		fm.<%=Webconst.Common.contentSeqName%>[<%=i%>].value = fm.<%=Webconst.Common.contentSeqName%>[<%=i%>].value+''+fm.file_rent_st[<%=i%>].value+''+fm.file_st[<%=i%>].value;
		<%		}%>
		<%	}%>		
				
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/fileuploadact.jsp?<%=Webconst.Common.contentCodeName%>=<%=UploadInfoEnum.LC_SCAN%>";				
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name="auth_rw" 		value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 		value="<%=user_id%>">
  <input type='hidden' name="br_id"   		value="<%=br_id%>">
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"		value="<%=rent_st%>">
  <input type='hidden' name="file_cnt" 		value="<%=vid_size%>">    
  <input type='hidden' name="fee_size" 		value="<%=fee_size%>">  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>스캔일괄등록</span></span></td>
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
    <tr>
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="10%" class=title>연번</td>
                  <td width="10%" class=title>계약</td>				  
                  <td width="30%" class=title>구분</td>                  
                  <td width="50%" class=title>스캔파일</td>
                </tr>				
		<%	for(int i=0;i < vid1.length;i++){
				content_seq = vid1[i];				
				file_rent_st 		= content_seq.substring(19,20);
				file_st			= content_seq.substring(20);
		%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center">
			<select name="file_rent_st" >					  
                            <option value="1" <%if(file_rent_st.equals("1")){%>selected<%}%>>신규</option>
			    <%	for(int j = 1 ; j < fee_size ; j++){%>
                            <option value="<%=j+1%>" <%if(file_rent_st.equals(String.valueOf(j+1))){%>selected<%}%>><%=j%>차연장</option>						
			    <%	}%>
                        </select> 
                    </td>
                    <td align="center">
        	        <select name="file_st" >
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>                            
                        </select> 
                    </td>	
                    <td align="center">
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=content_seq%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>									
                </tr>	
		<%	}%>	
		<%	if(vid1.length <12){%>
		<%		for(int i=vid1.length;i < 12;i++){
					file_st 	= "5";
					file_cont 	= "";
		%>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center">
			<select name="file_rent_st">					  
                            <option value="1" <%if(rent_st.equals("1")){%>selected<%}%>>신규</option>
			    <%	for(int j = 1 ; j < fee_size ; j++){%>
                            <option value="<%=j+1%>" <%if(rent_st.equals(String.valueOf(j+1))){%>selected<%}%>><%=j%>차연장</option>						
			    <%	}%>
                        </select> 			
                    </td>
                    <td align="center">
        	        <select name="file_st"> 
                            <%for(int j = 0 ; j < scan_code_size ; j++){
                                CodeBean scan_code = scan_codes[j];	%>
                            <option value="<%=scan_code.getNm_cd()%>" <%if(file_st.equals(scan_code.getNm_cd())){%> selected<%}%>><%=scan_code.getNm()%></option>
                            <%}%>            	        	                                                       
                        </select> 			
                    </td>	
                    <td align="center">
                        <input type="file" name="file" size="50" class=text>
                        <input type="hidden" name="<%=Webconst.Common.contentSeqName%>" value='<%=rent_mng_id%><%=rent_l_cd%>'>
                        <input type='hidden' name='<%=Webconst.Common.contentCodeName%>' value='<%=UploadInfoEnum.LC_SCAN%>'>                               			    
                    </td>									
                </tr>	
		<%		}%>			
		<%	}%>	
            </table>
        </td>
    </tr>
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
    
    <tr>
        <td align="right"><a href='javascript:save()'><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</center>
</body>
</html>
