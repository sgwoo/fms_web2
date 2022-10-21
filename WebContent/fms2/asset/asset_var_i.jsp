<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	
	String a_a = request.getParameter("a_a")==null?"":request.getParameter("a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	AssetDatabase a_db = AssetDatabase.getInstance();
	bean = a_db.getAssetVarCase(a_a, seq);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function save(cmd){
		var fm = document.form1;
		if(fm.a_a.value == ''){ alert('자산구분을 선택하십시오.'); return;}
		if(fm.a_1.value == ''){ alert('자산계정코드를 입력하십시오.'); return;}
		if(fm.b_1.value == ''){ alert('내용년수를 선택하십시오.'); return;}
		if(fm.b_2.value == ''){ alert('적용구분을 선택하십시오.'); return;}
		if(fm.c_1.value == ''){ alert('상각방법을 선택하십시오.'); return;}
		if(fm.d_1.value == ''){ alert('상각비계정을 입력하십시오.'); return;}
		
		if(cmd == 'i'){
					
			if(!confirm('등록하시겠습니까?')){	return;	}
		}else if(cmd == 'up'){
													
			if(!confirm('입력한 데이타로 업그레이드합니다.\n\n진짜로 업그레이드하시겠습니까?')){	return;	}						
		}else{
			if(!confirm('수정하시겠습니까?')){	return;	}		
		}
		fm.cmd.value = cmd;
		fm.target = "i_no";
		fm.submit();		
	}
	
	//목록보기
	function go_list(){
		location='asset_var_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>';
	}

//-->
</script>
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body>
<form name="form1" method="post" action="asset_var_a.jsp">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td><font color="navy">MASTER -> 코드관리 -&gt; </font><font color="red">자산변수관리
        </font></td>
    </tr>
    <tr> 
      <td align="right"> <%if(seq.equals("")){%>
	  <a href="javascript:save('i');">등록</a> 
	  <%}else{%>
	  <a href="javascript:save('u');">수정</a> 	  
	  <a href="javascript:save('up');">업그레이드</a> 	  	  
	  <%}%>
	  <a href="javascript:go_list();">목록</a></td>
      </td>
    </tr>
    <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
	       <td width=150 height=22 class=title>자산구분</td>
	       <td>&nbsp;<select name="a_a">
	                <option value="" >--선택--</option>
	                <option value="1" <%if(a_a.equals("1"))%>selected<%%>>리스사업자동차</option>
	                <option value="2" <%if(a_a.equals("2"))%>selected<%%>>렌트사업자동차</option>
	                </select></td>
	    </tr>
	       <tr bgcolor=#FFFFFF>
            <td height=22 class=title>자산계정코드</td>
            <td>&nbsp;<input type="text" name="a_1" size="10" value='<%=bean.getA_1()%>' class=text ></td>
        </tr>
	   </table>
	  </td>
	</tr>    
     	
    <tr>
	    <td height=22 >1. 내용년수</td>
	</tr>
	  
    <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>내용년수</td>
            <td>&nbsp;<input type="text" name="b_1" size="10" class=num value='<%=bean.getB_1()%>'></td></td>
     	</tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적용기준</td>
            <td>&nbsp;<select name="b_2">   
                <option value="">--선택--</option>                      
                <option value="1" <%if(bean.getB_2().equals("1"))%>selected<%%>>취득일자</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적용기준일</td>
            <td>&nbsp;<input type="text" name="b_3"   value='<%=AddUtil.ChangeDate2(bean.getB_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>변경일</td>
            <td>&nbsp;<input type="text" name="b_4"   value='<%=AddUtil.ChangeDate2(bean.getB_4())%>'   size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적요</td>
            <td>&nbsp;<textarea name=b_5 cols=100% rows=3><%=bean.getB_5()%></textarea></td>
        </tr>
      </table>
	 </td>
    </tr>
    <tr>
        <td height=25 >&nbsp;</td>
    </tr>
    
    <tr>
        <td height=22 >2. 상각방법</td>
    </tr>
	  
	<tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>상각방법</td>
            <td>&nbsp;<select name="c_1">
                <option value="">--선택--</option>                     
                <option value="1" <%if(bean.getC_1().equals("1"))%>selected<%%>>정액법</option> 
                <option value="2" <%if(bean.getC_1().equals("2"))%>selected<%%>>정률법</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>상각율</td>
            <td>&nbsp;<input type="text" name="c_2" size="10" class=num value='<%=bean.getC_2()%>'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적용기준일</td>
            <td>&nbsp;<input type="text" name="c_3"   value='<%=AddUtil.ChangeDate2(bean.getC_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>변경일</td>
            <td>&nbsp;<input type="text" name="c_4"   value='<%=AddUtil.ChangeDate2(bean.getC_4())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적요</td>
            <td>&nbsp;<textarea name=c_5 cols=100% rows=3><%=bean.getC_5()%></textarea></td>
        </tr>
	   </table>
	  </td>
	 </tr>
	 <tr>
        <td height=25 >&nbsp;</td>
     </tr>
     <tr>
        <td height=22 >3. 상각비계정</td>
     </tr>
	 
	 <tr>
      <td class=line><table border=0 cellspacing=1 width=800>
	    <tr>
            <td width=150 height=22 class=title>상각비계정</td>
            <td>&nbsp;<select name="d_1">
                <option value="">--선택--</option>                     
                <option value="1" <%if(bean.getD_1().equals("1"))%>selected<%%>>감가상각(리스)</option> 
                <option value="2" <%if(bean.getD_1().equals("2"))%>selected<%%>>감가상각(대여)</option>                 
            	</select></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>상각비계정코드</td>
            <td>&nbsp;<input type="text" name="d_2" size="10" value='<%=bean.getD_2()%>' class=text ></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적용기준일</td>
            <td>&nbsp;<input type="text" name="d_3"   value='<%=AddUtil.ChangeDate2(bean.getD_3())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>변경일</td>
            <td>&nbsp;<input type="text" name="d_4"   value='<%=AddUtil.ChangeDate2(bean.getD_4())%>'  size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr bgcolor=#FFFFFF>
            <td height=22 class=title>적요</td>
            <td>&nbsp;<textarea name=d_5 cols=100% rows=3><%=bean.getD_5()%></textarea></td>
        </tr>
	   </table>
	  </td>
	 </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
