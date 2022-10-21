<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	%>
	<%--  ------------------------------------
	s_kd<%=s_kd %>
	t_wd<%=t_wd %>
	gubun1<%=gubun1 %>
	gubun2<%=gubun2 %>
	gubun3<%=gubun3 %>
	st_dt<%=st_dt %>
	end_dt<%=end_dt %>
	sort<%=sort %>
	----------------------------------------   --%>
	<%
	Vector vt = ic_db.getInsComFilereqList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>

	/* Title 고정 */
	function setupEvents() {
		window.onscroll = moveTitle;
		window.onresize = moveTitle; 
	}
	
	function moveTitle() {
	    var X ;
	    document.all.tr_title.style.scrollTop = document.body.scrollTop;
	    document.all.td_title.style.scrollLeft = document.body.scrollLeft;
	    document.all.td_con.style.scrollLeft = document.body.scrollLeft;	    
	}
	
	function init() {
		setupEvents();
	}
	
	//전체선택
	function AllSelect() {
		var fm = document.form1;
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum = "";
		var allChk = fm.ch_all;
		 for (var i = 0; i < len; i++) {
			var ck = fm.ch_cd[i];
			 if (allChk.checked == false) {
				ck.checked = false;
			} else {
				ck.checked = true;
			}
		}
	}
	
	function openP(car_no, ins_con_no) {
		window.open("view_scan.jsp?car_no="+car_no+"&ins_con_no="+ins_con_no, "VIEW_SCAN", "left=100, top=100, width=720, height=350, scrollbars=yes");		
	}		

	var objPopup;
	function deletePopP(seq) {
		 objPopup = window.open("https://fms3.amazoncar.co.kr/fms2/attach/deleteact.jsp?SEQ="+seq+"&type=logical", "VIEW_SCAN", "left=100, top=100, width=10, height=10, scrollbars=yes");		
		
	}
	
	function deleteReq(reg_code,seq,file_seq) {
		if (confirm("해당 파일을 삭제 하시겠습니까?") == true) {
			if (file_seq) {
				deletePopP(file_seq);
			}
			setTimeout(function() {
				if(objPopup !=null ){
					objPopup.addEventListener('load',objPopup.close(), true);
				}
				var fm = document.form1;
				var gubun2 = fm.gubun2.value;
				var gubun3 = fm.gubun3.value;
				var st_dt = fm.st_dt.value;
				var end_dt = fm.end_dt.value;
				
				location.href = 'ins_com_filereq_del.jsp?reg_code='+reg_code+'&seq='+seq+'&gubun2='+gubun2+'&gubun3='+gubun3+'&st_dt='+st_dt+'&end_dt='+end_dt;
			}, 2000);
			
		}else{
			return;
		}
	}
	
	function updateReq(reg_code, seq) {
		var fm = document.form1;	
		var len = fm.elements.length;
		fm.reg_code.value = reg_code;
		fm.seq.value = seq;
		fm.action = 'ins_com_filereq_upd.jsp';
		fm.method = "post";
		fm.submit();	
	}
	
	function updateUseSt(reg_code, seq, use_st) {
		var fm = document.form1;	
		var len = fm.elements.length;
		fm.c_reg_code.value = reg_code;
		fm.c_seq.value = seq;
		fm.c_use_st.value = use_st;
		fm.gubun_st.value = 'c';
		fm.action = 'ins_com_filereq_upd.jsp';
		fm.method = "post";
		fm.submit();	
	}
	
	function onKeyDown(reg_code, seq) {
		updateReq(reg_code,seq);	
	}
	
	//메일수신하기
	function go_mail(rent_mng_id, rent_l_cd, ch_cd) {
		
		var fm = parent.document.form1;
		var checkScdFee_val = "";
		
		//가입증명서 요청시 대여료스케줄 같이발송	
		if (fm.check_scd_fee.checked == true) {
			checkScdFee_val = "Y";
		}
		
		var SUBWIN = "mail_input_comemp.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&ch_cd="+ch_cd+"&checkScdFee="+checkScdFee_val;
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}
	
	function view_client(m_id, l_cd, r_st)
	{
		window.open("/fms2/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st="+r_st, "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}

</script>

</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			
<input type='hidden' name='andor' value='<%=andor%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>  
<input type='hidden' name='gubun2' value='<%=gubun2%>'> 
<input type='hidden' name='gubun3' value='<%=gubun3%>'>       
<input type='hidden' name='st_dt' value='<%=st_dt%>'>  
<input type='hidden' name='end_dt' value='<%=end_dt%>'>        
<input type='hidden' name='sort' 	value='<%=sort%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_new_frame.jsp'>
<input type='hidden' name='size' value=''>
<input type='hidden' name='gubun_st' value=''>
<input type='hidden' name='c_reg_code' value=''>
<input type='hidden' name='c_seq' value=''>
<input type='hidden' name='c_use_st' value=''>
<input type='hidden' name='checkScdFee' value=''>
  
<div style="font-size:9pt;margin-bottom:5px;">
	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>공지내용</span>
</div>
<div style="color:#464e7c;font-size:9pt;background-color: #e2e7ff;border-top: 2px solid #b0baec;border-bottom: 0px solid #b0baec;font-weight:bold;">
<br>
	<div>&nbsp;&nbsp;&nbsp;
		<img src=/acar/images/center/arrow.gif align=absmiddle>&nbsp;&nbsp;
		 	<span style="">결산기간에는  <span style="color:#ef620c">4시</span> 기준으로 일괄 등록됩니다.</span>
		 	<br><br>
	</div>
	<div>&nbsp;&nbsp;&nbsp;
		<img src=/acar/images/center/arrow.gif align=absmiddle>&nbsp;&nbsp;
			[사고및보험 > 보험관리 > <span style="color:#ef620c">가입증명서요청등록</span> ] 메뉴에서 [구분 > <span style="color:#ef620c">완료</span>] 으로 검색하여
			<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			비고 란에 입력한 수신처는 직접 발송하시기 바랍니다.
			<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			※ 기본적으로 <span style="color:#ef620c">세금계산서 메일</span>로 발송
	</div>
	<br>
</div>
<br>
<table border="0" cellspacing="0" cellpadding="0" width='1670'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style="position:relative;z-index=1;">
		<td class='line' width='400' id='td_title' style='position:relative;'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
			<tr>
			    <td width='40' class='title'>연번</td>
			    <td width='40' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
	        	<td width='50' class='title'>보험</td>
	        	<td width='50' class='title'>상태</td>
	        	<td width='100' class='title'>등록일</td>
			    <td width="50" class='title'>등록자</td>
			</tr>
		    </table>
		</td>
		<td class='line' width='1140'>
		    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
			<tr>
			    <td width='200' class='title'>상호</td>
			    <td width='130' class='title'>사업자번호</td>
			    <td width='80' class='title'>차량번호</td>
			    <!-- <td width='150' class='title'>차대번호</td> -->
			    <td width='120' class='title'>계약번호</td>
			    <td width='120' class='title'>증권번호</td>
			    <td width='100' class='title'>보험시작일</td>
			    <td width='100' class='title'>보험만료일</td>
			    <td width='60' class='title'>파일</td>
			    <td width='60' class='title'>요청삭제</td>
			    <td width='200' class='title'>비고</td>
			    <td width='70' class='title'>메일<br>개별발송</td>
			</tr>
		    </table>
		</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='40' align='center'><div id="num"><%=i+1%></div></td>
		    <td width='40' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("FILE_SEQ")%>/<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>"></td>
		    <td width='50' align='center'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 3)%></td>
		    <td width='50' align='center'><%=ht.get("INS_STS")%></td>
		    <td width='100' align='center'><%=ht.get("REG_DT")%></td>
		    <td width='50' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line'>
	    <table id="listtable" border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
		<tr id="<%=ht.get("FILE_SEQ")%>">
		        <td width='200' align='center'>
					<%-- <a href="javascript:view_cont('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("USE_YN")%>','<%=ht.get("CAR_ST")%>', 
					'<%if(String.valueOf(ht.get("CNG_ST")).equals("")){%>
						<%if(String.valueOf(ht.get("EXT_ST")).equals("")){%>
							<%=ht.get("RENT_ST")%><%}else{%><%=ht.get("EXT_ST")%><%}%>
					<%}else{%>
							<%if(String.valueOf(ht.get("EXT_ST2")).equals("")){%>
								<%=ht.get("CNG_ST")%>
							<%}else{%>
								<%=ht.get("EXT_ST2")%>
							<%}%>
					<%}%>','<%if(String.valueOf(ht.get("USE_YN")).equals("") && String.valueOf(ht.get("SANCTION_ST")).equals("요청")){%>요청
							<%}else{%>
							<%}%>')" onMouseOver="window.status=''; return true" title='계약상세내역'>
					<%=Util.subData(String.valueOf(ht.get("FIRM_NM")),12)%></a> --%>
		         <a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("FEE_RENT_ST")%>')" onMouseOver="window.status=''; return true" title='계약약식내역'><span title='<%=ht.get("FIRM_NM")%>'><%=AddUtil.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></a></td>
		       </td>
		        <td width='130' align='center'><%=ht.get("ENP_NO")%></td>
		        <td width='80' align='center'><%=ht.get("CAR_NO")%></td>
		      <%--   <td width='150' align='center'><%=ht.get("CAR_NUM")%></td> --%>
		    <%--     <td width='120' align='center'><%=ht.get("RENT_L_CD")%></td> --%>
				<td width='120' align='center'>
					<%=ht.get("RENT_L_CD")%>
				</td>
		        <td width='120' id='ins_con_no<%=i%>' align='center'><%=ht.get("INS_CON_NO")%></td>
		        <td width='100' id='ins_start_dt<%=i%>' align='center'><%=ht.get("INS_START_DT")%></td>
		        <td width='100' id='ins_exp_dt<%=i%>' align='center'><%=ht.get("INS_EXP_DT")%></td>
		        <td width='60' align='center'>
		        <%if(!String.valueOf(ht.get("FILE_SEQ")).equals("")){ %>
		        	<%if(String.valueOf(ht.get("USE_ST")).equals("요청")){ %>
		        		<script>
		        			updateUseSt('<%=ht.get("REG_CODE")%>','<%=ht.get("SEQ")%>','완료');
		        		</script>
		        	<%}else{ %>		        
		        		<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("FILE_SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
		        	<%} %>
		        <%} %>
		        </td>
		        <%-- <td width='60' align='center'><a href="javascript:openP('<%=ht.get("CAR_NO")%>','<%=ht.get("INS_CON_NO")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td> --%>
		        <td width='60' align='center'>
	          <%-- 	<%if(String.valueOf(ht.get("FILE_SEQ")).equals("")){ %> --%>
			        <%if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || String.valueOf(ht.get("REG_ID")).equals(user_id)){%>
			        <a href="javascript:deleteReq('<%=ht.get("REG_CODE")%>','<%=ht.get("SEQ")%>','<%=ht.get("FILE_SEQ")%>');" title='요청삭제' ><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
					<%} %>
				<%-- <%} %> --%>
		        </td>
		        <td width='200'> 
		        	<input type="text" style="width:120px;" name="etc" value="<%=ht.get("ETC")%>"
		        	 onkeypress="if(event.keyCode==13)javascript:onKeyDown('<%=ht.get("REG_CODE")%>','<%=ht.get("SEQ")%>')">
		        	<a href="javascript:updateReq('<%=ht.get("REG_CODE")%>','<%=ht.get("SEQ")%>');" title='수정' >
		        	<img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
		        </td>
		        <td width='70' align='center'><a href="javascript:go_mail('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("FILE_SEQ")%>/<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>')" title='개별 메일 발송'><img src=/acar/images/center/button_in_email.gif align=absmiddle border=0></a></td>
		      	<input type='hidden' name='reg_code' value='<%=ht.get("REG_CODE")%>'>
  				<input type='hidden' name='seq' value='<%=ht.get("SEQ")%>'>
  				<input type='hidden' id="reg_id<%=i%>" name='reg_id<%=i%>' value='<%=ht.get("REG_ID")%>'>		
  				<input type='hidden' id="car_no<%=i%>" name='car_no<%=i%>' value='<%=ht.get("CAR_NO")%>'>		
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='400' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1070'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
<div style="height: 500px;"></div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

