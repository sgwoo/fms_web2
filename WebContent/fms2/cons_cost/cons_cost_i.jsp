<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "11", "02", "05");

	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getConsCostCarForm();
	int vt_size = vt.size();
	
	int row_size = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/acar/include/table.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/acar/include/info.js"></script>
<SCRIPT LANGUAGE="JavaScript">
<!--
	//등록하기
	function save(){
		fm = document.form1;
		if(fm.off_id.value == '')			{ alert('탁송업체를 선택하십시외.'); return; }
		if(fm.cost_b_dt.value == '')		{ alert('기준일자를 입력하십시외.'); return; }

		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'cons_cost_i_a.jsp';
		fm.submit();
	}
//-->
</SCRIPT>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</HEAD>
<BODY>
<p>
</p>
<form action="" method='post' name="form1">
<input type='hidden' name='vt_size' value='<%=vt_size%>'>
<input type='hidden' name='row_size' value=''>
<table border="0" cellspacing="0" cellpadding="0" width="1000">
  <tr>
    <td>&lt; 공통 &gt; </td>
  </tr>      
  <tr>
    <td class="line">
	  <table border="0" cellspacing="1" cellpadding="0" width=100%>  
        <tr>
    	  <td width="100" height="30" class="title">탁송업체</td>
    	  <td>&nbsp;
		      <select name='off_id'>
		      	    <option value='007751'>삼진특수</option>                                                        
                            <option value='009026'>영원물류</option>
                            <option value='011372'>상원물류(주)</option>
                            <option value='009771'>프로카비스</option>
                            <option value='010265'>신화로직스</option>                
                            <option value='010266'>대명운수</option>                  
                            <option value='010630'>동운로지스</option>                
              </select>
          </td>
        </tr>
        <tr>
    	  <td width="100" height="30" class="title">기준일자</td>
    	  <td>&nbsp;
		  <input name="cost_b_dt" type="text" class=text value=""size="12"></td>
        </tr>
	  </table>
	</td>
  </tr>  
  <tr>
    <td>&nbsp;</td>
  </tr>    
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  
			  <tr>
			    <td width="100" rowspan="2" class="title">제조사</td>
			    <td width="200" rowspan="2" class="title">차명</td>
			    <td width="100" rowspan="2" class="title">출하장</td>				
				<td colspan="5" class="title">인수지점</td>
			   </tr>
			   <tr>
			    <td width="100" class="title">서울본사</td>
			    <td width="100" class="title">부산지점</td>
			    <td width="100" class="title">대전지점</td>				
			    <td width="100" class="title">대구지점</td>
			    <td width="100" class="title">광주지점</td>				
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
			  <%	if(String.valueOf(ht.get("NM")).equals("현대자동차")){	row_size=row_size+2;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='울산' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='아산' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <%	}%>
			  <%	if(String.valueOf(ht.get("NM")).equals("기아자동차")){	row_size=row_size+3;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='소하리' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='화성' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='서산' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <%	}%>
			  <%	if(String.valueOf(ht.get("NM")).equals("르노코리아자동차(주)")){	row_size=row_size+1;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='부산' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <%	}%>		
			  <%	if(String.valueOf(ht.get("NM")).equals("한국지엠(주)")){	row_size=row_size+3;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='창원' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='군산' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='인천' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <%	}%>		
			  <%	if(String.valueOf(ht.get("NM")).equals("쌍용자동차(주)")){	row_size=row_size+1;%>
			  <tr>
			    <td align="center"><%=ht.get("NM")%><input type='hidden' name='car_comp_nm' value='<%=ht.get("NM")%>'><input type='hidden' name='car_comp_id' value='<%=ht.get("CAR_COMP_ID")%>'></td>
			    <td align="center"><%=ht.get("CAR_NM")%><input type='hidden' name='car_nm' value='<%=ht.get("CAR_NM")%>'><input type='hidden' name='car_cd' value='<%=ht.get("CAR_CD")%>'></td>
			    <td align="center"><input type='text' name="from_place" value='평택' size='10' class='text'></td>
			    <td align="center"><input type='text' size='9' name='to_place1' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place2' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place3' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place4' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			    <td align="center"><input type='text' size='9' name='to_place5' maxlength='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
			  </tr>			  
			  <%	}%>					  	  	  
			  <%}%>			  
            </table>
        </td>
    </tr>
  <tr>  
    <td align="center">[<%=row_size%>건]&nbsp; 
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
        <%}%>
        <a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--
	document.form1.row_size.value = <%=row_size%>;
//-->
</SCRIPT>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>