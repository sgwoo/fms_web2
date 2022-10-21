<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.consignment.*, acar.user_mng.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
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
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = cs_db.getConsignmentPurEndList(s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	
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
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		 
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}		
//-->
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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'> 
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/cons_pur/consp_end_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='udt_dt' value='<%=AddUtil.getDate()%>'>      
<table border="0" cellspacing="0" cellpadding="0" width='1600'>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='490' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='30' class='title'  style='height:51'>연번</td>
		    <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
		    <td width='30' class='title'>상태</td>
		    <td width='110' class='title'>제조사</td>				  
		    <td width='110' class='title'>계출번호</td>
		    <td width='100' class='title'>차종</td>
		    <td width='80' class='title'>최초등록일</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1110'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="6" class='title'>배달탁송</td>	    
		    <td colspan="3" class='title'>판매지점</td>	    		    
		    <td width="70" rowspan="2" class='title'>출고대리인</td>
		    <td width="150" rowspan="2" class='title'>등록일시</td>
		</tr>
		<tr>
		    <td width='100' class='title'>탁송업체</td>
		    <td width='80' class='title'>출고일자</td>
		    <td width='80' class='title'>출고사무소</td>
		    <td width='80' class='title'>탁송지점</td>
		    <td width='150' class='title'>배달지</td>
		    <td width='80' class='title'>탁송료</td>
		    <td width='150' class='title'>지점명</td>
		    <td width='100' class='title'>담당자</td>
		    <td width='100' class='title'>연락처</td>
		</tr>
	    </table>
	</td>
    </tr>
<%	if(vt_size > 0)	{%>
    <tr>
	<td class='line' width='490' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		<tr>
		    <td  width='30' align='center'><%=i+1%></td>		    
		    <td  width='30' align='center'>
		        <%if(!String.valueOf(ht.get("DLV_DT")).equals("") && String.valueOf(ht.get("UDT_DT")).equals("") && String.valueOf(ht.get("REQ_CODE")).equals("")){%>
		            <input type="checkbox" name="ch_cd" value="<%=ht.get("CONS_NO")%>">
		        <%}%>
		    </td>		    
		    <td  width='30' align='center'><%=ht.get("USE_ST_NM")%></td>
		    <td  width='110' align='center'><span title='<%=ht.get("CAR_COMP_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_COMP_NM")), 6)%></span></td>
		    <td  width='110' align='center'><a href="javascript:parent.view_cons('<%=ht.get("CONS_NO")%>', '<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RPT_NO")%></a></td>					
		    <td  width='100' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 6)%></span></td>
		    <td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>
		</tr>
<%		}%>
		<tr>
		    <td class='title' colspan='7'>합계</td>		    
		</tr>
	    </table>
	</td>
	<td class='line' width='1110'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);			
%>
		<tr>				
		    <td  width='100' align='center'><%=ht.get("OFF_NM")%></td>
		    <td  width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("DLV_DT")))%></td>
		    <td  width='80' align='center'><%=ht.get("DLV_EXT")%></td>
		    <td  width='80' align='center'><%=ht.get("UDT_ST_NM")%></td>
		    <td  width='150' align='center'><span title='<%=ht.get("UDT_FIRM")%>'><%=Util.subData(String.valueOf(ht.get("UDT_FIRM")), 10)%></span></td>
		    <td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("CONS_AMT1")))%></td>
		    <td  width='150' align='center'><span title='<%=ht.get("CAR_OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_OFF_NM")), 6)%></span></td>		
		    <td  width='100' align='center'><%=ht.get("EMP_NM")%></td>
		    <td  width='100' align='center'><%=ht.get("EMP_TEL")%></td>
		    <td  width='70' align='center'><%=ht.get("DRIVER_NM")%></td>										
		    <td  width='150' align='center'><%=ht.get("REG_DT")%></td>												    
		</tr>
<%			total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("CONS_AMT1")));
		}%>
		<tr>											
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>					
		    <td class='title'>&nbsp;</td>					
		    <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>					
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		    <td class='title'>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>	
<%	}else{%>
    <tr>
	<td class='line' width='490' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
			<%if(t_wd.equals("")){%>검색어를 입력하십시오.
			<%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1110'>
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
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>
