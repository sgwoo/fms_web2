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
	InsComDatabase ic_db = InsComDatabase.getInstance();
	
	Vector vt = ic_db.getInsComCngList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
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
		 
		var chkLen = $("#tbdy tr").length;
		 
     	for(var i=0; i<chkLen; i++) {
     		$("input:checkbox[name=ch_cd2]").eq(i).prop("checked",false);
     	}
		 
		 $("input:checkbox[name=ch_cd]:checked").each(function(i,elements) {
         	var index = $(elements).index("input:checkbox[name=ch_cd]");
//          	console.log("index > " + index);
         	$("input:checkbox[name=ch_cd2]").eq(index).prop("checked",true);
         });
	}	
	
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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
  <input type='hidden' name='from_page' value='/fms2/ins_com/ins_com_cng_frame.jsp'>
  <input type='hidden' name='reg_code' value=''>
  <input type='hidden' name='seq' value=''>
  <input type='hidden' name='size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width='5380'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='470' id='td_title' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='50' class='title' style='height:51'>연번</td>
		    <td width='50' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='50' class='title'>점검</td>
		    <td width='120' class='title'>보험사</td>
		    <td width='50' class='title'>상태</td>
            <td width='100' class='title'>등록일</td>
		    <td width='50' class='title'>등록자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='4680'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="13" class='title'>요청</td>
		    <td colspan="26" class='title'>결과</td>
		</tr>
		<tr>
		    <td width='100' class='title'>차량번호</td>
		    <td width='150' class='title'>증권번호</td>
		    <td width='200' class='title'>고객</td>
		    <td width='200' class='title'>상호(보험사용)</td>
		    <td width='80' class='title'>고객구분</td>
		    <td width='150' class='title'>차명</td>	
		    <td width='100' class='title'>사업자번호</td>
		    <td width='100' class='title'>보험시작일</td>
		    <td width='100' class='title'>보험만료일</td>
		    <td width='100' class='title'>배서항목명</td>	
		    <td width='400' class='title'>변경전</td>
		    <td width='400' class='title'>변경후</td>
		    <td width='150' class='title'>변경사유</td>	
		    <td width='100' class='title'>변경요청일</td>
		    <td width='150' class='title'>비고</td>
		    <td width='100' class='title'>증권번호</td>
		    <td width='100' class='title'>차량번호</td>
		    <td width='100' class='title'>결제예정금액</td>
		    <td width='100' class='title'>배서기준일</td>
		    <td width='100' class='title'>대인배상Ⅰ</td>
		    <td width='100' class='title'>대인배상Ⅱ</td>
		    <td width='100' class='title'>대물배상</td>
		    <td width='100' class='title'>자기신체사고</td>
		    <td width='100' class='title'>무보험차상해</td>
		    <td width='100' class='title'>분담금할증</td>
		    <td width='100' class='title'>자기차량손해</td>
		    <td width='100' class='title'>긴급출동</td>
		    <td width='100' class='title'>총보험료</td>
		    <td width='80'  class='title'>임직원</td>
		    <td width='80'  class='title'>차선(제어)</td>
		    <td width='80'  class='title'>차선(경고)</td>
		    <td width='80'  class='title'>긴급(제어)</td>
		    <td width='80'  class='title'>긴급(경고)</td>
		    <td width='80'  class='title'>전기차</td>
		    <td width='80'  class='title'>견인고리</td>
		    <td width='100'  class='title'>법률비용지원금</td>
		    <td width='100' class='title'>기타장치</td>
		    <td width='100' class='title'>피보험자변경</td>
		    <td width='300' class='title'>비고</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
     <tr>
	<td class='line' width='470' id='td_con' style='position: sticky;left: 0;z-index: 1;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' id="tbl">
	    <tbody id="tbdy">
                
        <%	
        		int cnt = 0;
        		boolean updateChk = false;
                for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				cnt  = ic_db.getCheckOverInsCng(String.valueOf(ht.get("VALUE02")),String.valueOf(ht.get("INS_ST")),String.valueOf(ht.get("VALUE17")));
				//결제금액 중복건에 대한 값 세팅(etc : 동일결제금액으로 확인가능)
				if(cnt > 1){
					updateChk = ic_db.updateInsExcelComCng(String.valueOf(ht.get("REG_CODE")), String.valueOf(ht.get("SEQ")));
				}
		
		%>
		
		
		<tr>
		    <td width='50' align='center'><%=i+1%></td>
		    <td width='50' align='center'>
	    		<input type="checkbox" name="ch_cd" value="<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>/<%=i%>">
	    		<input type="checkbox" name="ch_cd2" value="<%=ht.get("REG_CODE")%>/<%=ht.get("SEQ")%>/<%=i%>/<%=ht.get("VALUE08")%>/<%=ht.get("RENT_MNG_ID")%>/<%=ht.get("RENT_L_CD")%>/<%=ht.get("VALUE10")%>" style="display:none">
		    </td>
		    <td width='50' align='center'><input type='text' name='chk_cont' size='3' class='whitetext' value=''></td>
		    <td width='120' align='center'><span title='<%=ht.get("INS_COM_NM")%>'><%=Util.subData(String.valueOf(ht.get("INS_COM_NM")), 7)%></span></td>
		    <td width='50' align='center'><%=ht.get("USE_ST")%></td>
		    <td width='100' align='center'><%=ht.get("REG_DT2")%></td>
		    <td width='50' align='center'><span title='<%=ht.get("REG_NM")%>'><%=Util.subData(String.valueOf(ht.get("REG_NM")), 3)%></span></td>
		</tr>
		<%	}%>
		</tbody>
	    </table>
	</td>
	<td class='line' width='4680'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
						
		%>			
		<tr>
		        <td width='100' align='center'><a href="javascript:parent.view_ins_com('<%=ht.get("REG_CODE")%>', '<%=ht.get("SEQ")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><%=ht.get("VALUE01")%></a></td>
		        <td width='150' align='center'><%=ht.get("VALUE02")%></td>
		        <td width='200' align='center'><span title='<%=ht.get("VALUE03")%>'><%=Util.subData(String.valueOf(ht.get("VALUE03")), 15)%></span></td>
		        <td width='200' align='center'><span title='<%=ht.get("VALUE36")%>'><%=Util.subData(String.valueOf(ht.get("VALUE36")), 20)%></span></td>
		        <td width='80' align='center'><span title='<%=ht.get("VALUE37")%>'><%=ht.get("VALUE37")%></span></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE04")%>'><%=Util.subData(String.valueOf(ht.get("VALUE04")), 10)%></span></td>
		        <td width='100' align='center'><%=ht.get("VALUE05")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE06")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE07")%></td>
		        <td width='100' align='center'><span title='<%=ht.get("VALUE08")%>'><%=Util.subData(String.valueOf(ht.get("VALUE08")), 7)%></span></td>
		        <td width='400' align='center'><span title='<%=ht.get("VALUE09")%>'><%=Util.subData(String.valueOf(ht.get("VALUE09")), 38)%></span></td>
		        <td width='400' align='center'><span title='<%=ht.get("VALUE10")%>'><%=Util.subData(String.valueOf(ht.get("VALUE10")), 38)%></span></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE11")%>'><%=Util.subData(String.valueOf(ht.get("VALUE11")), 10)%></span></td>
		        <td width='100' align='center'><%=ht.get("VALUE12")%></td>
		        <td width='150' align='center'><span title='<%=ht.get("VALUE13")%>'><%=Util.subData(String.valueOf(ht.get("VALUE13")), 10)%></span></td>
		        <td width='100' align='center'><%=ht.get("VALUE15")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE16")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE17")%></td>
		        <td width='100' align='center'><%=ht.get("VALUE18")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE19")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE20")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE21")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE22")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE23")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE24")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE25")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE26")%></td>
		        <td width='100' align='right'><%=ht.get("VALUE27")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE28")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE29")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE30")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE31")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE32")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE33")%></td>
		        <td width='100'  align='center'><%=ht.get("VALUE34")%></td>
		        <td width='100'  align='center'><%=ht.get("VALUE38")%></td>
		        <td width='80'  align='center'><%=ht.get("VALUE39")%></td>
		        <td width='100'  align='center'><%=ht.get("VALUE40")%></td>
		        <td width='300'>&nbsp;<%=ht.get("ETC")%></td>
<%-- 		        <input type="hidden" name="value08" id="value08" value='<%=String.valueOf(ht.get("VALUE08"))%>'/> --%>
<%-- 		        <input type="hidden" name="rent_mng_id" value='<%=String.valueOf(ht.get("RENT_MNG_ID"))%>'/> --%>
<%-- 		        <input type="hidden" name="rent_l_cd" value='<%=String.valueOf(ht.get("RENT_L_CD"))%>'/> --%>
<%-- 		        <input type="hidden" name="value10" value='<%=String.valueOf(ht.get("VALUE10"))%>'/> --%>
		       
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	 
    <%	}else{%>                     
    <tr>
	<td class='line' width='470' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='4680'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->

// $(document).ready(function(){
//     $("input[name=ch_cd]").change(function(){
//         if($("input[name=ch_cd]").is(":checked")){
//         }else{
//         }
//     });
// });

$(document).ready(function(){
	$("input:checkbox[name=ch_cd]").change(function(){
        if($("input:checkbox[name=ch_cd]").is(":checked")){
        	var len = $("#tbdy tr").length;
        	for(var i=0; i<len; i++) {
        		$("input:checkbox[name=ch_cd2]").eq(i).prop("checked",false);
        	}
            $("input:checkbox[name=ch_cd]:checked").each(function(i,elements) {
            	var index = $(elements).index("input:checkbox[name=ch_cd]");
//             	console.log(index);
            	$("input:checkbox[name=ch_cd2]").eq(index).prop("checked",true);
            });
        }else{
        	$("input:checkbox[name=ch_cd2]").eq(index).prop("checked",false);
        }
    });
});



</script>
</body>
</html>

