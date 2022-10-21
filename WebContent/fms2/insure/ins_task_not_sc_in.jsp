<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	InsEtcDatabase ie_db = InsEtcDatabase.getInstance();
	Vector vt = ie_db.getInsTaskNotStatList(s_kd, t_wd, gubun1, gubun2,st_dt,end_dt,gubun3, gubun4, gubun5);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents()
	{
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop 	= document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft 	= document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft		= document.body.scrollLeft ;   	    
	    
	}
	function init() {		
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
	
	//메일수신하기
	function go_mail(rent_mng_id, rent_l_cd, car_mng_id){			
		var SUBWIN="mail_input_task.jsp?rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&car_mng_id="+car_mng_id;
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}		
	function view_scan(m_id, l_cd){
		window.open("/fms2/lc_rent/scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}		
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
//		window.open("/fms2/con_fee/fee_memo_frame_s.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "FEE_MEMO", "left=0, top=0, width=850, height=750, scrollbars=yes");
	}	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post' action=''>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			  
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1600' style="margin-bottom:100px;">
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='320' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='40' rowspan="2" class='title'>연번</td>
		    <td width='40' rowspan="2" class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td colspan="2" class='title'>차량사항</td>
		</tr>    
		<tr>
		    <td width='90' class='title'>차량번호</td>		    
		    <td width='150' class='title'>차명</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1280'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='150' rowspan="2" class='title'>고객</td>
		    <td width='130' rowspan="2" class='title'>사업자번호</td>
		    <td colspan="4" class='title'>계약정보</td>
		    <td colspan="5" class='title'>보험정보</td>
		    <td width='60' rowspan="2" class='title'>최초<br>영업자</td>
		    <td width='60' rowspan="2" class='title'>영업<br>담당자</td>
		    <td width='100' rowspan="2" class='title'>가입요청서<br>웹페이지</td>
		    <td width='70' rowspan="2" class='title'>메일<br>개별발송</td>
		</tr>
		<tr>
		    <td width='80' class='title'>대여개시일</td>
		    <td width='80' class='title'>대여만료일</td>
		    <td width='80' class='title'>임직원보험</td>
		    <td width='80' class='title'>스캔</td>
		    <td width='80' class='title'>보험회사</td>
		    <td width='80' class='title'>보험시작일</td>
		    <td width='80' class='title'>보험만료일</td>
		    <td width='80' class='title'>임직원보험</td>
		    <td width='80' class='title'>장기임차인</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%if(vt_size > 0){%>
    <tr>
	<td class='line' width='320' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        	<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
             %>
		<tr>
		    <td width='40' align='center'><a href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=i+1%></a></td>
		    <td width='40' align=center><input type="checkbox" name="ch_l_cd" value="<%=ht.get("CLIENT_ID")%>/<%=ht.get("CAR_MNG_ID")%>"></td>
		    <td width='91' align='center'><%=ht.get("CAR_NO")%></td>		    
		    <td width='150' align='center'><span title='<%=ht.get("CAR_NM")%> <%=ht.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM"))+" "+String.valueOf(ht.get("CAR_NAME")), 10)%></span></td>		    
		</tr>
           	<%}%>
	    </table>
	</td>
	<td class='line' width='1280'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
                %>			
		<tr>
		    <td width='151' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 8)%></span></td>
		     <%if(Integer.parseInt(String.valueOf(ht.get("CNT")))>1){ %>
			     <td width='128' align='center' style=" background-color: lavender;"><%=ht.get("ENP_NO")%></td>
		     <%}else{ %>
			     <td width='128' align='center'><%=ht.get("ENP_NO")%></td>
		     <%} %>
		    <td width='80' align='center'><%=ht.get("RENT_START_DT")%></td>
		    <td width='80' align='center'><%=ht.get("RENT_END_DT")%></td>
		    <td width='80' align='center'><%=ht.get("CONT_COM_EMP_YN")%></td>
		    <td width='80' align='center'><a href="javascript:view_scan('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" class="btn" title='스캔관리'><img src=/acar/images/center/button_in_scan.gif align=absmiddle border=0></a>&nbsp;</td>
		    <td width='80' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 4)%></span></td>
		    <td width='80' align='center'><%=ht.get("INS_START_DT")%></td>
		    <td width='80' align='center'><%=ht.get("INS_EXP_DT")%></td>
		    <td width='80' align='center'><%=ht.get("INS_COM_EMP_YN")%></td>
		    <td width='80' align='center'>
			    <span title='<%=ht.get("FIRM_EMP_NM")%>'>
				    <%if((ht.get("FIRM_NM"+"")).equals(ht.get("FIRM_EMP_NM")+"")){%>
				    	<%=Util.subData(String.valueOf(ht.get("FIRM_EMP_NM")),5)%>
				    <%}else{%>
				    	<font style="color:red;"><%=Util.subData(String.valueOf(ht.get("FIRM_EMP_NM")),5)%></font>
				    <%}%>
			    </span>
		    </td>
		    <td width='60' align='center'><%=ht.get("BUS_NM")%></td>
		    <td width='60' align='center'><%=ht.get("BUS_NM2")%></td>
		    <td width='100' align='center'><a href='/fms2/lc_rent/task_doc_ins.jsp?client_id=<%=ht.get("CLIENT_ID")%>&user_id=<%=ht.get("BUS_ID2")%>&car_mng_id=<%=ht.get("CAR_MNG_ID")%>&rent_l_cd=<%=ht.get("RENT_L_CD")%>'' target="_blank"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
		    <td width='70' align='center'><a href="javascript:go_mail('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("CAR_MNG_ID")%>')" title='개별 메일 발송'><img src=/acar/images/center/button_in_email.gif align=absmiddle border=0></a></td>
		</tr>
<%
		}
%>
			</table>
		</td>
<%	}
	else
	{
%>                     
	<tr>
		<td class='line' width='320' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1000'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</form>
<script language='javascript'>

	parent.document.form1.size.value = '<%=vt_size%>';

</script>
</body>
</html>
