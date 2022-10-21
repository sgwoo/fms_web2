<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.common.*, acar.client.*, acar.car_register.*, acar.cooperation.* "%>
<%@ page import="acar.accid.*, acar.res_search.*, acar.cont.*, acar.short_fee_mng.*, acar.user_mng.*, acar.estimate_mng.*"%>
<jsp:useBean id="a_db" scope="page" 	class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" 	class="acar.fee.AddFeeDatabase"	/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String seq_no 	= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");//사고관리일련번호
	String client_id= request.getParameter("client_id")==null?"":request.getParameter("client_id");//고객관리번호
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	String bus_id2 	= "";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CooperationDatabase co_db 	= CooperationDatabase.getInstance();
	
	Hashtable con = a_db.getContCase(l_cd);
	
	m_id = String.valueOf(con.get("RENT_MNG_ID"));
	c_id = String.valueOf(con.get("CAR_MNG_ID"));
	
	String rent_st = String.valueOf(con.get("RENT_ST"));
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(String.valueOf(cont.get("CLIENT_ID")));
	
	//대여료갯수조회(연장여부)
	int fee_size = af_db.getMaxRentSt(m_id, l_cd);
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
		
	int count = 0;
  	String file_st = "";
    String file_rent_st = "";
	String contentNm ="";
	
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
			
	content_code = "FINE_DOC";
	
	Vector conProof = co_db.getContProofList(l_cd);		
	int conProof_size = conProof.size();
	
	content_code = "OFF_DOC";
	content_seq  = "docs1";
	
	Vector amazon_attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int amazon_attach_vt_size = amazon_attach_vt.size();	
	

	SimpleDateFormat mSimpleDateFormat = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
	Date currentTime = new Date ();
	String mTime = mSimpleDateFormat.format ( currentTime );
	
	
	
	CarRegDatabase crd = CarRegDatabase.getInstance();
	//차량번호 이력
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script src='/include/common.js'></script>
<script>
function addr_ask_appl_reg(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "addr_ask_appl_reg.jsp";
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function doc_cert_print(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/insa_card/doc_cert_stamp.jsp?user_id="+'<%=ck_acar_id%>';
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function war_cert_print(){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/insa_card/war_cert.jsp?user_id="+'<%=ck_acar_id%>';
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
function fee_scd_print(m_id, l_cd){
	var fm = document.form1;	
	 window.open("" ,"form1", 
     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
	fm.action = "/fms2/con_fee/fee_scd_print_ext.jsp?m_id="+m_id+"&l_cd="+l_cd;
	//fm.target = "_blank";
	fm.target = "form1";
	fm.method="post";
	fm.submit();	
}	
//전체선택
function AllSelect(){
	var fm = document.form1;
	var len = fm.ch_cd.length;
	var cnt = 0;
	var idnum ="";
	var allChk = fm.ch_all;
	 for(var i=0; i<len; i++){
		var ck = fm.ch_cd[i];
		 if(allChk.checked == false){
			ck.checked = false;
		}else{
			ck.checked = true;
		} 
	} 
}	

//선택출력
function Accid_ReqDoc_Print(){
	var fm = document.form1;	
	var len=fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				idnum=ck.value;
			}
		}
	}			
	if(cnt == 0){
	 	alert("인쇄할 문서를 선택하세요.");
		return;
	}	
	
	if(confirm('청구서류를 선택 인쇄하시겠습니까?')){
		 window.open("" ,"form1", 
	     "toolbar=no, width=800, height=930, directories=no, status=no,    scrollorbars=no, resizable=no"); 
		//fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/cooperation_u3_print.jsp";
		fm.action = "cooperation_u4_print.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method="post";
		fm.submit();	
	}
}		
</script>
</head>
<body>
<form action="" name="form1">
<input type="hidden" name="rent_l_cd" value="<%=l_cd%>">
<input type="hidden" name="rent_mng_id" value="<%=m_id%>">
<input type="hidden" name="rent_st" value="<%=rent_st%>">
<input type="hidden" name="seq" value="<%=seq%>">
<table border="0" cellspacing="0" cellpadding="0" width=670>
	<tr>
    	<td colspan="2">
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style1>운행정지명령요청 ><span class=style5>스캔관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
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
                    <td width='35%'>&nbsp;<%=l_cd%></td>
                    <td class='title' width='15%'>상호</td>
                    <td width='35%'>&nbsp;<%=client.getFirm_nm()%>&nbsp;<%=cont.get("CLIENT_NM")%></td>
                </tr>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<%=cont.get("CAR_NO")%></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<%=cont.get("CAR_NM")%> <%=cont.get("CAR_NAME")%></td>
                </tr>
				<%for(int i=1; i<=fee_size; i++){
						ContFeeBean fees = a_db.getContFeeNew(m_id, l_cd, Integer.toString(i));
//						ContCarBean fee_etcs = a_db.getContFeeEtc(m_id, l_cd, Integer.toString(i));%>
                <tr>
					<td class='title'>대여기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>				
                    <td class='title'>대여개월</td>
                    <td>&nbsp;<%=fees.getCon_mon()%>개월<%if(i>1){%>(연장)<%}%></td>
                    
                </tr>						
				<%}%>
                <tr> 
                    <td class='title'>우편물주소</td>
                    <td colspan=''>&nbsp;<%=client.getHo_zip()%>&nbsp;<%= client.getHo_addr()%>&nbsp;<%=client.getClient_nm()%></td>
					<td class='title'>전화번호</td>
                    <td colspan=''>&nbsp;<%if(!client.getO_tel().equals("")){%><%=client.getO_tel()%><%}else{%><%=client.getM_tel() %><%} %></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
    </tr>
    <tr>
        <td colspan="2" class=h></td>
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
		    <td class="title" width='3%'></td>
		    <td class='title' width='3%'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td class="title" width='8%'>계약</td>
		    <td class="title" width='29%'>구분</td>                    
		    <td class="title" width='30%'>파일보기</td>
		    <td class="title" width='20%'>등록일</td>
		</tr>
		
		 <% if(amazon_attach_vt_size > 0){
			for (int j = 0 ; j < amazon_attach_vt_size ; j++){
				Hashtable ht = (Hashtable)amazon_attach_vt.elementAt(j);
				if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).equals("docs1")){
					/* 	rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 	 */					
						contentNm =  String.valueOf(ht.get("FILE_NAME"));
						contentNm = contentNm.substring(0,contentNm.lastIndexOf("."));
						if(!contentNm.equals("") && contentNm.contains("법인등기부등본")) contentNm ="아마존카 법인등기부등본";
						else if(!contentNm.equals("") && contentNm.contains("사업자등록증")) contentNm ="아마존카 사업자등록증";
						else if(!contentNm.equals("") && contentNm.contains("법인인감증명서")) contentNm ="아마존카 법인인감증명서";
				}
	
			if(!contentNm.equals("") && !contentNm.contains("법인인감증명서") ){
	%>                
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     		<%if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){ %>
     			<input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht.get("SEQ"))%>">
     		<%} %>
     		</td>
			<td align="center">아마존카</td>		
     		<td align="center"><%=contentNm%></td>
			<td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src='/acar/images/center/button_in_print.gif' border=0></a></td>
			<td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
		</tr>
		<%
			count++;
			}		
		}
		
	  }
	  %>
  		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<!-- <input type="checkbox" name="ch_cd" value="doc3"> -->
     		</td>
		    
			<td align="center">아마존카</td>
     		<td align="center">대여료스케줄표</td>
			<td align="center">
				<a href="javascript:fee_scd_print('<%=m_id%>','<%=l_cd%>')"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<input type="checkbox" name="ch_cd" value="doc1">
     		</td>
		    
			<td align="center">아마존카</td>
     		<td align="center">재직증명서</td>
			<td align="center">
				<a href="javascript:doc_cert_print()"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     			<input type="checkbox" name="ch_cd" value="doc2">
     		</td>
		    
			<td align="center">아마존카</td>
     		<td align="center">위임장</td>
			<td align="center">
				<a href="javascript:war_cert_print()"><img src='/acar/images/center/button_in_print.gif' border=0></a>
			<!-- 	&nbsp;
				<a href="javascript:addr_ask_appl_reg()"><img src='/acar/images/center/button_in_reg.gif' border=0></a> -->
			</td>
			<td align="center"><div><%=mTime.substring(0,10)%></div><div><%=mTime.substring(10,19)%>.0 <%=session_user_nm%></div></td>
		</tr> 
		<%	
			count++;
		%>
		
		<%
		if(ch_r.length > 0){
			for(int i=0; i<ch_r.length; i++){
				ch_bean = ch_r[i];
				content_code = "CAR_CHANGE";
				content_seq  = c_id+""+ch_bean.getCha_seq();

				Vector car_attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int car_attach_vt_size = car_attach_vt.size();
				
				if(car_attach_vt_size > 0){
					for (int j = 0 ; j < car_attach_vt_size ; j++){
						Hashtable attach_ht = (Hashtable)car_attach_vt.elementAt(j);
		%>		
			<tr>
			    <td align="center"><%= count+1 %></td>
		    		<td width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=String.valueOf(attach_ht.get("SEQ"))%>"> </td>
			    
				<td align="center">아마존카</td>
		    		<td align="center">자동차 등록증</td>
				<td align="center"><a href="javascript:openPopP('<%=attach_ht.get("FILE_TYPE")%>','<%=attach_ht.get("SEQ")%>');" title='보기' ><%=attach_ht.get("FILE_NAME")%></a></td>
				<td align="center"><%=attach_ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(attach_ht.get("REG_USERSEQ")),"USER")%></td>
			</tr>
		<%				count++;
					}
				}
			}
		}
       	%>
		
		
		<%
       	if(conProof_size > 0){
				for (int i = 0 ; i < conProof_size ; i++){
					Hashtable ht2 = (Hashtable)conProof.elementAt(i);
		%>
			<tr>
			    <td align="center"><%= count+1 %></td>
		    		<td width='30' align='center'><%-- <input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht2.get("SEQ"))%>"> --%></td>
			    
				<td align="center">아마존카</td>
		    		<td align="center">내용증명발송내역</td>
				<td align="center"><a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a></td>
				<td align="center"><%=ht2.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht2.get("REG_USERSEQ")),"USER")%></td>
			</tr>
		<%	
			count++;
			}
		}
       	%>
	  
	  
	  <% if(attach_vt_size > 0){
			for (int j = 0 ; j < attach_vt_size ; j++){
				Hashtable ht = (Hashtable)attach_vt.elementAt(j);
				
				if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){
						rent_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(19,20);
						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
						contentNm = c_db.getNameByIdCode("0028", "", file_st);	
				}
	
			if(!contentNm.equals("")){
				if(contentNm.contains("대여") || contentNm.contains("사업자등록증")){
	%>                
		<tr>
		    <td align="center"><%= count+1 %></td>
     		<td width='30' align='center'>
     		<%if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){ %>
     			<input type="checkbox" name="ch_cd" value="<%=String.valueOf(ht.get("SEQ"))%>">
     		<%} %>
     		</td>
			<td align="center">
			<%if(rent_st.equals("1") || rent_st.equals("")){%>	
				신규
			<%}else{%>		
				<%=AddUtil.parseInt(rent_st)-1%>차연장<%}%>
			</td>		
     		<td align="center"><%=contentNm%></td>
			<td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
			<td align="center"><%=ht.get("REG_DATE")%>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_USERSEQ")),"USER")%></td>
		</tr>
		<%
			count++;
				}
			}		
		}
	  }
	  %>
<%-- 	  <%
	  	if(attach_vt_size ==0 && amazon_attach_vt_size == 0){%>
		<tr>
		    <td colspan="6" class=""><div align="center">해당 스캔파일이 없습니다.</div></td>
		</tr>
		<%}%> --%>
		</table>
    </tr>
 </table>
 <div style="font-size:10pt;">* 신청자 신분증은 직접 복사하여 첨부하시기 바랍니다.</div>
 <div style="font-size:10pt;">* PDF파일은 개별로 출력하시기 바랍니다.</div>
 <div style="text-align:center;margin-top:40px;">
 	<a href="javascript:Accid_ReqDoc_Print()"><img src='/acar/images/button_print.gif' border=0></a>
</div>
</form>
</body>
</html>
