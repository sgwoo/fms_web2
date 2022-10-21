<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1		= request.getParameter("gubun1")==null?"8":request.getParameter("gubun1");
	String minus		= request.getParameter("minus")==null?"":request.getParameter("minus");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"))-200;//상단길이
	
	int count =0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = ac_db.Mtel_ScanList(dt, ref_dt1, ref_dt2, "8", minus);
	int vt_size = vt.size();
	
	long t_amt1[] = new long[1];
	long t_amt2[] = new long[1];
	long t_amt3[] = new long[1];
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
	int j1 = 0;
	int g1 = 0;
	int s2 = 0;
	int dept1 = 0;
	int dept2 = 0;
	int dept3 = 0;
	int dept4 = 0;
	int dept5 = 0;
	int dept9 = 0;
	int dept10 = 0;
	int dept11 = 0;
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	
	for(int j = 0 ; j < vt_size ; j++){
		Hashtable ht2 = (Hashtable)vt.elementAt(j);
	
		if(ht2.get("BR_NM").equals("본사")){
			
			s1++;
			
			if(ht2.get("DEPT_NM").equals("영업팀")){
				dept1++;
			}else if(ht2.get("DEPT_NM").equals("고객지원팀")){
				dept2++;
			}else if(ht2.get("DEPT_NM").equals("총무팀")){
				dept3++;
			}
		}else if(ht2.get("BR_NM").equals("부산")){
			b1++;
			dept3++;
		}else if(ht2.get("BR_NM").equals("대전")){
			d1++;
			dept4++;
		}else if(ht2.get("BR_NM").equals("광주")){
			j1++;
			dept10++;
		}else if(ht2.get("BR_NM").equals("대구")){
			g1++;
			dept11++;
		}else if(ht2.get("BR_NM").equals("강남")){
			s2++;
			dept9++;
		}

			

	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	int size = 0;

	
		}
%>

<html>
<head><title>FMS</title>

<script language='javascript'>
	var popObj = null;
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
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
//	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//첨부파일 보기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		
		theURL = "https://fms3.amazoncar.co.kr/data/mtel_scan/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}
	
	//등록한것 삭제하기
	function mtel_scan_del()
{
	var theForm = document.form1;
		
	if(confirm('삭제하시겠습니까?')){	
		theForm.action='mtel_scan_a.jsp?cmd=d';		
		theForm.target='i_no';
		theForm.submit();
	}
	
}
	
	//수정하기
	function upd_car(seq, gubun, id, file){
	var SUBWIN="mtel_scan_upd.jsp?seq="+seq+"&gubun="+gubun+"&id="+id+"&file="+file;	
		window.open(SUBWIN, "upd_car", "left=100, top=50, width=630, height=400, scrollbars=yes");
	}
	
//스캔등록
function scan_reg(save_dt, seq, yy, mm, gubun){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&save_dt="+save_dt+"&seq="+seq+"&c_yy="+yy+"&c_mm="+mm+"&gubun="+gubun, "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
}

function delete2(save_dt, seq, yy, mm, gubun,seq1)
{
	var fm = document.form1;
	var fm2 = document.form2;
	fm2.save_dt.value = save_dt;
	fm2.seq.value = seq;
	fm2.yy.value = yy; 
	fm2.mm.value = mm; 
	fm2.gubun.value = gubun; 

	
	if(!confirm('삭제하시겠습니까?'))
	{
		return;
	}

	if(seq1==''){

	}else{
		file_delete(seq1);

	}
	
	fm2.target = "i_no";
	fm2.action = "./mtel_scan_del.jsp";	
	fm2.submit();
}

function file_delete(seq1){
		var fm = document.form1;	
		fm.target = "_blank";
		fm.action = "https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq1;
		fm.submit();
		
}




//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<input type='hidden' name='id' value=''>
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='scanfile_nm' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='800'>
    <tr>
        <td class=line2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'> 
		<td class='line' width='100%' id='td_title' style='position:relative;'>
			<table border=0 cellspacing=1 width=100%>
				<tr> 
					<td class='title' width='10%'>연번</td>
					<td class='title' width='10%'>지점</td>
					<td class='title' width='10%'>부서</td>
					<td class='title' width='10%'>사원번호</td>
					<td class='title' width='10%'>성명</td>
					<td class='title' width='50%'>영수증파일</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=line2>
			<table border=0 cellspacing=1 width=100%>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			

%>             	
				<tr>
            		<td width='10%' align="center"><%=i+1%></td>
            		<td width='10%' align="center"><%=ht.get("BR_NM")%></td>
					<td width='10%' align="center"><%=ht.get("DEPT_NM")%></td>
					<td width='10%' align="center"><%=ht.get("ID")%></td>
					<td width='10%' align="center"><%=ht.get("USER_NM")%></td>
               		<td width='50%' align="center">
					<%if(!ht.get("FILE_NAME").equals("")){
					seq1 = "";
					%>
										<a href="javascript:MM_openBrWindow('<%=ht.get("FILE_NAME")%>','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
									<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
										<a href="javascript:delete2('<%=ht.get("SAVE_DT")%>','<%=ht.get("SEQ")%>','<%=ht.get("C_YY")%>','<%=ht.get("C_MM")%>','<%=ht.get("GUBUN")%>','<%=seq1%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
									<%}%>
					<%}else{%>
								<%
								String content_code = "STAT_CMP";
									String content_seq  = (String)ht.get("SAVE_DT")+(String)ht.get("SEQ")+(String)ht.get("C_YY")+(String)ht.get("C_MM")+(String)ht.get("GUBUN");
								
									Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
									int attach_vt_size = attach_vt.size();
									
									for(int k=0; k< attach_vt.size(); k++){
										Hashtable aht = (Hashtable)attach_vt.elementAt(k);   
										
										if((content_seq).equals(aht.get("CONTENT_SEQ"))){
											file_name1 = String.valueOf(aht.get("FILE_NAME"));
											file_type1 = String.valueOf(aht.get("FILE_TYPE"));
											seq1 = String.valueOf(aht.get("SEQ"));
									
										}
									}
										if(!file_name1.equals("")){
								
								%>
											<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
														<a href="javascript:openPopP('<%=file_type1%>','<%=seq1%>');" title='보기' ><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
											<%}else{%>
														<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
											<%}%>
														 &nbsp;<a href="javascript:delete2('<%=ht.get("SAVE_DT")%>','<%=ht.get("SEQ")%>','<%=ht.get("C_YY")%>','<%=ht.get("C_MM")%>','<%=ht.get("GUBUN")%>','<%=seq1%>')"><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
								<%
								}else{%>
												<a href="javascript:scan_reg('<%=ht.get("SAVE_DT")%>','<%=ht.get("SEQ")%>','<%=ht.get("C_YY")%>','<%=ht.get("C_MM")%>','<%=ht.get("GUBUN")%>')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
								<%}%>
					<%}%>
					</td>
            	</tr>
<% }	%>

<% }else{%>            	
	            <tr>
    	            <td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
        	    </tr>
<%}%>        	    
            </table>
        </td>
    </tr>
</table>
</form>
<form action="" name="form2" method="POST">
<input type='hidden' name='id' value=''>
<input type='hidden' name='gubun' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='scanfile_nm' value=''>
<input type='hidden' name='save_dt' value=''>
<input type='hidden' name='yy' value=''>
<input type='hidden' name='mm' value=''>
</form>
</body>
</html>
