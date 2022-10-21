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
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getInsComFileList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>

	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
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
	
	//순번선택
	function orderSelect(){
		var fm = document.form1;
		var len = fm.ch_cd.length;
		var cnt = 0;
		var idnum ="";
		var orderChk = fm.ch_order;
		 for(var i=0; i<len; i++){
			var st = fm.sort[i+1];
			var ck = fm.ch_cd[i];
			 if(orderChk.checked == false){
				ck.checked = false;
			}else{
				if (st.value) {
					ck.checked = true;
				}
			} 
		} 
	}
	
	
	
	
	
	
	function openP(car_no, ins_con_no){
		window.open("view_scan.jsp?car_no="+car_no+"&ins_con_no="+ins_con_no, "VIEW_SCAN", "left=100, top=100, width=720, height=350, scrollbars=yes");		
	}		


	
	
	function onKeyDown(seq,  value ){
		regSort(seq,value);
	}
	
	//메일수신하기
	function go_mail(rent_mng_id, rent_l_cd, ch_cd) {
		var fm = parent.document.form1;
		var checkScdFee_val = "";
		
		//가입증명서 요청시 대여료스케줄 같이발송	
 		if (fm.check_scd_fee.checked == true) {
			checkScdFee_val = "Y";
		}
		
		var SUBWIN = "mail_input_comemp2.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&ch_cd="+ch_cd+"&checkScdFee="+checkScdFee_val;
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}
	
	function regSort(seq, value){
		var url = 'ins_com_file_sort.jsp?seq='+seq+'&sort='+value;
		var specs = "left=10,top=10,width=572,height=166";
		specs += ",toolbar=no,menubar=no,status=no,scrollbars=yes,resizable=no";
		window.open(url, "popup", specs);
	}
	
	function sorting(){
		var fm = document.form1;
		 window.open("" ,"form1", 
	       "toolbar=no, width=572, height=166, directories=no, status=no,    scrollorbars=no, resizable=no"); 
		fm.action = "ins_com_file_sort_all.jsp";
		//fm.target = "_blank";
		fm.target = "form1";
		fm.method="post";
		fm.submit();	
	}

</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_new_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
  <input type='hidden' name='checkScdFee' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='1700'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='500' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title'>연번</td>
		    <td width='50' class='title'>순번<input type="checkbox" name="ch_order" value="Y" onclick="javascript:orderSelect();"></td>
		    <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='100' class='title'>보험사</td>
        <td width='100' class='title'>등록일</td>
		    <td width="100" class='title'>등록자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1100'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='100' class='title'>차량번호</td>
		    <td width='150' class='title'>증권번호</td>
		   <!--  <td width='200' class='title'>상호</td> -->
		    <td width='150' class='title'>차명</td>
		    <td width='100' class='title'>보험시작일</td>
		    <td width='100' class='title'>보험만료일</td>
		    <td width='100' class='title'>사업자번호</td>
		    <td width='60' class='title'>파일</td>
		    <td width='60' class='title'>이력</td>
		   <%if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
		    <td width='60' class='title'>삭제</td>
		    <%} %>
		    <td width='70' class='title'>메일<br>개별발송</td>
		    <%if(gubun4.equals("변경")){%>
		    <td width='100' class='title'>변경요청일</td>
		    <%} %>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='500' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='50' align='center'><%=i+1%></td>
		    <td width='50' align='center'><input type="text" value="<%=ht.get("SORT")%>" maxlength="2" name="sort" tabindex=1
		    onkeypress="if(event.keyCode==13)javascript:onKeyDown('<%=ht.get("SEQ")%>',this.value)" style="text-align:center;width:25px;" ></td>
		    <td width='50' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("SEQ")%>"></td>
		    <td width='100' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 3)%></span></td>
		    <td width='100' align='center'><%=ht.get("REG_DT2")%></td>
		    <td width='100' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
			<input type="hidden" name="seq"  value="<%=ht.get("SEQ")%>" />
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='1100'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		        <td width='100' align='center'><%=ht.get("CAR_NO")%></td>
		        <td width='150' align='center'><%=ht.get("INS_CON_NO")%></td>
		        <%-- <td width='200' align='center'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 10)%></td> --%>
		        <td width='150' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 10)%></span></a></td>
		        <td width='100' align='center'><%=ht.get("INS_START_DT")%></td>
		        <td width='100' align='center'><%=ht.get("INS_EXP_DT")%></td>
		        <td width='100' align='center'><%=ht.get("ENP_NO")%></td>
		        <td width='60' align='center'><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
		        <td width='60' align='center'><a href="javascript:openP('<%=ht.get("CAR_NO")%>','<%=ht.get("INS_CON_NO")%>');" title='보기' ><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
		        <% %>
		        <%if(nm_db.getWorkAuthUser("보험담당",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
		        <td width='60' align='center'>
		        	<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank' title='삭제' ><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
		        </td>
				<%} %>
				  
				<td width='70' align='center'><a 	href="javascript:go_mail('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>','<%=ht.get("SEQ")%>/<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>')"	title='개별 메일 발송'>
					 <%if(!String.valueOf(ht.get("INS_START_DT")).equals("")){%>
						<img src=/acar/images/center/button_in_email.gif align=absmiddle	border=0></a>
					<%} %>
				</td>
				<%if(gubun4.equals("변경")){%>
					<td width='100' align='center'><%=ht.get("VALUE12")%></td>
				<%} %>
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='500' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1100'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
<div style="height: 500px;">
	 <input style="margin:5px 45px;"type="button" class="button btn-submit" value="정렬" onclick="sorting()"/>
</div>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

